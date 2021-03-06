#* Copyright (C) 2020 LithiumOS-Team
#	 This file is part of the Lithium Kernel.
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as
#    published by the Free Software Foundation, either version 3 of the
#    License, or (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.#
#
#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.
#*/
INCPATH = /home/alan/git/Lithium-OS/lib
MKDIR =  /home/alan/git/Lithium-OS/build
CC = gcc
CPP = g++
LD = ld
GAS = as
IAS = nasm
LIBDIRM = -I $(INCPATH)
CMKLG = 
CMKFLGS=-fno-builtin $(LIBDIRM) -m32 -c -Wall -nostdinc -nostdlib -fno-pie
#/*-fno-builtin $(LIBDIRM) -m32 -c -Wall -nostdinc -nostdlib*/
#/*-mcmodel=large -fno-builtin $(LIBDIRM) -m64 -c -Wall -nostdinc -nostdlib*/
export CC
export CPP
export LD
export GAS
export IAS
export MKDIR
export LIBDIRM
export CMKLG
export CMKFLGS
system:
	@echo "\033[34m[II] Setting INCPATH to $(INCPATH)\033[0m"
	make clean
	time make all
	@echo "\033[34m[II] Compile Complete.\033[0m"
	@echo "\033[34m[II] Kernel:$(MKDIR)/lithium.elf\033[0m"
	@echo "\033[0m"
	ls -l $(MKDIR)/lithium.elf
	@echo "\033[34m"
	objdump -f $(MKDIR)/lithium.elf
	@echo "\033[34m[II] Checking Vaild MB2\033[0m"
	make chkmb
	@echo "\033[32m KERNEL : OK\033[0m"

all:kernel.o
	@echo "\033[34m[II] Linking\033[0m"
	ld -z max-page-size=0x1000 -m elf_i386 -T kernel.lds --build-id=none $(MKDIR)/*.o -o $(MKDIR)/lithium~dirty.o
	@echo "\033[34m[II] Cleaning Other Section\033[0m"
	objcopy -R ".eh_frame" -R ".comment" -O elf32-i386 $(MKDIR)/lithium~dirty.o $(MKDIR)/lithium.elf
clean:
	rm -rf $(MKDIR)
	mkdir $(MKDIR)
kernel.o:libs kheader.o
	@echo "\033[34m[II] Making Kernel\033[0m"
	$(CC) $(CMKFLGS) kernel.c -o $(MKDIR)/kernel.o $(CMKLG)
	@echo "\033[34m[II] EveryLib is Ok,Start Linking\033[0m"
kheader.o:kheader.s
	@echo "\033[34m[II] Making KernelHeader\033[0m"
	$(GAS) --32 -o $(MKDIR)/kheader.o kheader.s
	objcopy -O elf32-i386 $(MKDIR)/kheader.o $(MKDIR)/kheader.o
	@echo "\033[34m[II] Header is OK\033[0m"
dmp:
	objdump -s $(MKDIR)/lithium.elf
sdmp:
	objdump -Ss $(MKDIR)/lithium.elf
chkmb:
	grub-file --is-x86-multiboot2  $(MKDIR)/lithium.elf && echo "\033[34m[II] Vaild Multiboot Header\033[0m" ||echo "\033[34m[II] Invaild Multiboot Header\033[0m"
install:system
	sudo cp $(MKDIR)/lithium.elf /lithium.elf
d8g:install
	sudo mount /dev/sdb1 $(MKDIR)
	sudo cp /lithium.elf $(MKDIR)/lithium.elf
	sync
	sync
	sync
	sudo umount /dev/sdb1
	sudo qemu-system-i386 -s -S -m 512 /dev/sdb
run:install
	sudo mount /dev/sdb1 $(MKDIR)
	sudo cp /lithium.elf $(MKDIR)/lithium.elf
	sync
	sync
	sync
	sudo umount /dev/sdb1
	sudo qemu-system-i386 -s -m 512 /dev/sdb
LIBSO = lib-sys lib-video lib-dsk lib-mem
libs:$(LIBSO)
	@echo "\033[34m[II] All Libs Ok\033[0m"
lib-dsk:
	@echo "\033[34m[II] Making Disk Lib\033[0m"
	make -C ./disk lib-dsk
lib-sys:

	@echo "\033[34m[II] Making Interrupt Lib\033[0m"
	make -C ./interrupt lib-intr
lib-video:
	@echo "\033[34m[II] Making Video Lib\033[0m"
	make -C ./video lib-video
lib-mem:
	@echo "\033[34m[II] Making Memory Lib\033[0m"
	make -C ./memory lib-mem
