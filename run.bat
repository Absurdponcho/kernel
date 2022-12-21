set OSNAME=CustomOS
set WORKING_FILE=%0
:: remove double quotes that are around "%0" or builddir and ovmfdir get ugly
set FIXED_WORKING_FILE=%WORKING_FILE:"=%
set BUILDDIR=%FIXED_WORKING_FILE%/../bin
set OVMFDIR=%FIXED_WORKING_FILE%/../../OVMFbin

qemu-system-x86_64 -drive "file=%BUILDDIR%/%OSNAME%.img" -m 256M -cpu qemu64 -drive "if=pflash,format=raw,unit=0,file=%OVMFDIR%/OVMF_CODE-pure-efi.fd,readonly=on" -drive "if=pflash,format=raw,unit=1,file=%OVMFDIR%/OVMF_VARS-pure-efi.fd" -net none
pause
