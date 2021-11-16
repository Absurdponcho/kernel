OUTPUT_FORMAT(elf64-x86-64)
ENTRY(_start)

SECTIONS
{
    .text : ALIGN(0x100)
    {
        *(.text)
    }
    .data : ALIGN(0x100)
    {
        *(.data)
    }
    .rodata : ALIGN(0x100)
    {
        *(.rodata)
    }
    .bss : ALIGN(0x100)
    {
        *(COMMON)
        *(.bss)
    }
}