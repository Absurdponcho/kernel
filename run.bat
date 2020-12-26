set OSNAME=CustomOS
set BUILDDIR=%~dp0\bin
set OVMFDIR=%~dp0\..\OVMFbin

qemu-system-x86_64 -drive file=%BUILDDIR%\%OSNAME%.img -m 256M -cpu qemu64 -drive if=pflash,format=raw,unit=0,file=%OVMFDIR%\OVMF_CODE-pure-efi.fd,readonly=on -drive if=pflash,format=raw,unit=1,file=%OVMFDIR%\OVMF_VARS-pure-efi.fd -net none
pause
