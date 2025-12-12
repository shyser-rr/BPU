.section .text.init
.global _start

_start:
    # Initialize Stack Pointer to the end of memory
    # We assume you have 4KB of RAM (0x1000 bytes)
    li sp, 0x1000  

    # Jump to C code
    call main

    # If main returns, loop forever (trap)
loop:
    j loop