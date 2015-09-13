# Makefile格式：
# target: dependancy1 dependancy2...
# 	command (command which will generate 'target' from 'dependancy1', 'dependancy2', ...)
# 命令行执行"make target"即可，如果不带target，默认指定Makefile中的第一个target
#
# $^代表target文件的所有dependancy文件
# $<代表第一个dependancy文件
# $@代表target文件
#

# 环境：linux32

all: os_image

os_image: boot_sector.v14.bin kernel.bin 15sector
	cat $^ > $@

boot_sector.v14.bin: boot_sector.v14.asm
	nasm $< -f bin -o $@

kernel.bin: kernel_entry.o kernel.o
	ld -o $@ -Ttext 0x1000 --oformat binary $^

kernel_entry.o: kernel_entry.asm
	nasm $< -f elf -o $@

kernel.o: kernel.c
	gcc -ffreestanding -c $< -o $@

15sector:
	dd if=/dev/zero of=$@ bs=512 count=15 2> /dev/null

clean:
	rm *.bin *.o 15sector os_image
