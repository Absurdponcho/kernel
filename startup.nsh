@echo -off
mode 80 25
;foundimage section is simply to locate the correct drive
cls
if exist .\efi\boot\main.efi then
 .\efi\boot\main.efi
 goto END
endif
if exist fs0:\efi\boot\main.efi then
 fs0:
 echo Found kernel on fs0:
 efi\boot\main.efi
 goto END
endif
if exist fs1:\efi\boot\main.efi then
 fs1:
 echo Found kernel on fs1:
 efi\boot\main.efi
 goto END
endif
if exist fs2:\efi\boot\main.efi then
 fs2:
 echo Found kernel on fs2:
 efi\boot\main.efi
 goto END
endif
 echo "Unable to find kernel".
 
:END