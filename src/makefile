CC_PATH = $(CROSS_PATH)/$(GCC_TARGET)-gcc
AS_PATH = $(CROSS_PATH)/$(GCC_TARGET)-as
CC_FLAGS = -std=gnu99 -ffreestanding -O2 -Wall -Wextra

usage:
	@echo "hello"

compile:
	mkdir tmp
#	$(AS_PATH) boot.s -o tmp/boot.o
#	nasm -o tmp/boot.o -felf32 boot.asm
#	$(CC_PATH) -c main.c -o tmp/main.o $(CC_FLAGS)
#	cp linker.ld tmp/linker.ld
#	cd tmp && $(CC_PATH) -T linker.ld -o harpiaos.bin -ffreestanding -O2 -nostdlib *.o -lgcc
#	grub-file --is-x86-multiboot2 tmp/harpiaos.bin && echo $$?
	cd hal && $(MAKE) compile
	mkdir -p ../boot/grub
	cp tmp/hal.bin ../boot/harpiaos.bin
	cp grub.cfg ../boot/grub/grub.cfg
	rm -r tmp

createdisk:
	dd if=/dev/zero of=disk.img bs=512 count=20480
	sfdisk disk.img < disk.sfdisk
	losetup /dev/loop0 disk.img
	losetup /dev/loop1 disk.img -o 1048576
	mkdosfs -F32 -f 2 /dev/loop1
	mount /dev/loop1 /mnt
	grub-install --root-directory=/mnt --no-floppy --modules="normal part_msdos fat exfat ext2 multiboot2" /dev/loop0
	losetup -d /dev/loop0
	umount /mnt
	losetup -d /dev/loop1
	cp disk.img ../clear.img
	rm disk.img