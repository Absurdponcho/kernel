
OSNAME = CustomOS

GNUEFI = ../gnu-efi
OVMFDIR = ../OVMFbin
EFI_LDS = $(GNUEFI)/gnuefi/efl_x86_84_efi.lds
CC = x86_64-w64-mingw32-gcc

LIBEFI = $(GNUEFI)/x86_64/lib

CFLAGS = -ffreestanding -I$(GNUEFI)/inc -I$(GNUEFI)/inc/x86_64 -I$(GNUEFI)/inc/protocol -fshort-wchar
LDFLAGS = -I $(EFI_LDS) -shared -Bsymbolic -nostdlib -Wl,-dll -shared -Wl,--subsystem,10 -e efi_main -lgcc

SRCDIR := src
OBJDIR := tmp
BUILDDIR := build

rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))

SRC = $(call rwildcard,$(SRCDIR),*.c)          
OBJS = $(patsubst $(SRCDIR)/%.c, $(OBJDIR)/%.o, $(SRC))
DIRS = $(wildcard $(SRCDIR)/*)

all: setup objs data link

setup:
	@if [ -d "$(OBJDIR)" ]; then echo "$(OBJDIR) exists"; else mkdir $(OBJDIR); fi
	@if [ -d "$(BUILDDIR)" ]; then echo "$(BUILDDIR) exists"; else mkdir $(BUILDDIR); fi

objs : $(OBJS)                      

$(OBJDIR)/%.o: $(SRCDIR)/%.c
	@ echo !==== COMPILING $^
	@ mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $^ -o $@ 

data:
	@ echo !==== COMPILING $(GNUEFI)/lib/data.c
	$(CC) -c $(GNUEFI)/lib/data.c -o $(OBJDIR)/data.o $(CFLAGS)
	
link: 
	@ echo !==== LINKING 
	$(CC) $(LDFLAGS) -o $(BUILDDIR)/BOOTX64.EFI $(OBJS) $(OBJDIR)/data.o
	
buildimg:
	dd if=/dev/zero of=$(BUILDDIR)/$(OSNAME).img bs=512 count=93750
	mformat -i $(BUILDDIR)/$(OSNAME).img -f 1440 ::
	mmd -i $(BUILDDIR)/$(OSNAME).img ::/EFI
	mmd -i $(BUILDDIR)/$(OSNAME).img ::/EFI/BOOT
	mcopy -i $(BUILDDIR)/$(OSNAME).img $(BUILDDIR)/BOOTX64.EFI ::/EFI/BOOT

run:
	qemu-system-x86_64 -drive file=$(BUILDDIR)/$(OSNAME).img -m 256M -cpu qemu64 -drive if=pflash,format=raw,unit=0,file="$(OVMFDIR)/OVMF_CODE-pure-efi.fd",readonly=on -drive if=pflash,format=raw,unit=1,file="$(OVMFDIR)/OVMF_VARS-pure-efi.fd" -net none


.PHONY: clean
clean:
	@rm -r $(OBJDIR)
	@mkdir $(OBJDIR)
	
	@rm -r $(BUILDDIR)
	@mkdir $(BUILDDIR)
	
	@echo Project cleaned. /$(OBJDIR) and /$(BUILDDIR) folders have been emptied
       