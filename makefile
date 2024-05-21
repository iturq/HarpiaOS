export GCC_VERSION = 13.2.0
export BINUTILS_VERSION = 2.42
#export GCC_TARGET = i686-elf
export GCC_TARGET = x86_64-elf
export CROSS_SOURCE = $(CURDIR)/tools/src
export CROSS_PREFIX= $(CURDIR)/tools/cross
export CROSS_PATH = $(CROSS_PREFIX)/bin
#export TMP_PATH = $(CURDIR)/tmp

help:
	@echo "usage make"

essentials:
	apt install build-essential bison flex libgmp3-dev libmpc-dev libmpfr-dev libisl-dev texinfo -y

all: downloadtools installtools compile

downloadtools:
	mkdir -p tools
	cp toolsmake tools/makefile
	cd tools &&	$(MAKE) downloadtools
#	curl http://ftp.gnu.org/gnu/gcc/gcc-$(GCC_VERSION)/gcc-$(GCC_VERSION).tar.gz -o tools/gcc.tar.gz
#	curl https://ftp.gnu.org/gnu/binutils/binutils-$(BINUTILS_VERSION).tar.xz -o tools/binutils.tar.gz

installtools:
	cd tools &&	$(MAKE) installtools

compile:
	$(CROSS_PATH)/$(GCC_TARGET)-gcc --version
	mkdir -p tmp
	cd src && $(MAKE) compile

removetmp:
	rm -r tmp

loaddisk: clear.img
	cp clear.img disk.img
	losetup /dev/loop1 disk.img -o 1048576
	mount /dev/loop1 /mnt
	cp -r boot/ /mnt/
	umount /mnt
	losetup -d /dev/loop1

clear.img:
	cd src && $(MAKE) createdisk

createimage:
	cd src && $(MAKE) createdisk

sourcerepository:
#	git clone $(REPOSITORY_URL)

test:
	cd src && $(MAKE) test

test2:
	cd src && $(MAKE) loaddisk