# MASTER MAKEFILE FOR RISC-V BPU
CC = riscv64-unknown-elf-gcc
OBJCOPY = riscv64-unknown-elf-objcopy
OBJDUMP = riscv64-unknown-elf-objdump

# RV32I = 32-bit Integer only (No floats, no atomics)
# -O0 = No optimization (easier to debug)
# -nostdlib = Don't look for standard libraries, we are bare metal
CFLAGS = -march=rv32i -mabi=ilp32 -O0 -g -Wall -nostdlib
LDFLAGS = -T common/linker.ld

# Source files
SRCS = common/start.S apps/main.c

# Output names
ELF = output.elf
HEX = instructions.hex

all: $(HEX)

# Step 1: Compile C and Assembly into an ELF file
$(ELF): $(SRCS)
	$(CC) $(CFLAGS) $(LDFLAGS) $^ -o $@

# Step 2: Extract only the instruction section into a raw Hex file
$(HEX): $(ELF)
	$(OBJCOPY) -O verilog --only-section=.text $< $@
	# Also dump the assembly so we can read it to debug
	$(OBJDUMP) -D $(ELF) > assembly.dump

clean:
	rm -f *.elf *.hex *.dump