MEMORY
{
    MEM : ORIGIN = 0x0, LENGTH = 0x4000
    RAM : ORIGIN = 0x20000000, LENGTH = 0x800
}

SECTIONS
{
    .text : {
        . = ALIGN(4);      /* Ensure code ends on a word boundary */
        *(.vectors*)
        *(.text*)
        . = ALIGN(4);      /* Ensure _sidata starts on a word boundary */
    } > MEM

    /* Use LOADADDR to get the address in MEM where .data is stored */
    _sidata = LOADADDR(.data); 

    .data : {
        . = ALIGN(4);
        _sdata = .;
        *(.data*)
        . = ALIGN(4);
        _edata = .;
    } > RAM AT > MEM
}