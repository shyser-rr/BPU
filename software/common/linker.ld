OUTPUT_ARCH( "riscv" )
ENTRY( _start )

SECTIONS
{
  /* Text = Code. Put this at 0x00000000 so the CPU reads it first */
  . = 0x00000000;
  .text : {
    *(.text.init) /* The bootloader goes first */
    *(.text)      /* Your main code goes next */
  }

  /* Data = Global Variables. */
  .data : {
    *(.data)
  }

  /* BSS = Uninitialized Variables. */
  .bss : {
    *(.bss)
  }
}