ENTRY(_start)

SECTIONS {
    . = 0x400000;
    .text : {
        KEEP(*(.text._start))
        *(.text*)
        *(.rodata*)
    }

    . = ALIGN(4096);
    .data : {
        *(.data*)
    }

    . = ALIGN(4096);
    .bss (NOLOAD) : {
        __bss_start = .;
        *(.bss*)
        *(COMMON)
        __bss_end = .;
    }

    /DISCARD/ : {
        *(.comment*)
        *(.eh_frame*)
        *(.debug*)
        *(.note*)
        *(.got.plt)
        *(.gnu.hash)
        *(.dynsym)
        *(.dynstr)
    }
}