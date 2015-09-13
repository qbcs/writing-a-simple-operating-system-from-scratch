# 用通用规则写Makefile
# 环境：linux32

# wildcard declaration
# Automatically expand to a list of existing files that
# match the patterns
C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS   = $(wildcard kernel/*.h drivers/*.h)
# Create a list of object files to build, simple by replacing 
# the '.c' extentions of filenames in C_SOURCES with '.o'
OBJ = ${C_SOURCES:.c=.o}

all: os_image

os_image: boot/boot_sector.v15.bin kernel/kernel.bin others/15sector
	cat $^ > $@

# Link kernel object files into one binary, making sure the 
# entry code is right at the start of the binary
kernel/kernel.bin: kernel/kernel_entry.o ${OBJ}
	ld -o $@ -Ttext 0x1000 --oformat binary $^
# Generic rule for building 'somefile.o' from 'somefile.c'
%.o : %.c ${HEADERS}
	gcc -ffreestanding -c $< -o $@
# Assemble the kernel_entry
%.o : %.asm
	nasm $< -f elf -o $@

# boot sector ?
%.bin : %.asm
	nasm $< -f bin -o $@

others/15sector:
	dd if=/dev/zero of=$@ bs=512 count=15 2> /dev/null

clean:
	rm kernel/kernel.bin others/15sector os_image ${OBJ} boot/boot_sector.v15.bin kernel/kernel_entry.o
