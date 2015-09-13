#!/bin/sh
# 环境：linux32
# 在使用Makefile工具之前使用的build脚本，建议废弃，采用make命令来构建

nasm kernel_entry.asm -f elf -o kernel_entry.o
gcc -ffreestanding -c kernel.c -o kernel.o
ld -o kernel.bin -Ttext 0x1000 --oformat binary kernel_entry.o kernel.o
nasm boot_sector.v14.asm -f bin -o boot_sector.v14.bin
#dd if=/dev/zero of=15sector bs=512 count=15 2> /dev/null
cat boot_sector.v14.bin kernel.bin 15sector > os_image
