define newline


endef

BUILD_DIR := build
USR_BUILD_DIR := $(BUILD_DIR)/usr

LD := ld
CC := gcc
CXX := g++
AS := nasm

ARCH := x86

LD_FLAGS := -n -melf_i386 -T arch/$(ARCH)/script/linker.ld -static --no-ld-generated-unwind-info
AS_FLAGS := -g -f elf32 -F dwarf -I arch/$(ARCH)/asm/

kernel_target :=$(BUILD_DIR)/kernel-$(ARCH).bin
iso_target := $(BUILD_DIR)/kernel-$(ARCH).iso

asm_src_files := $(wildcard arch/$(ARCH)/asm/*.s)
asm_obj_files := $(patsubst arch/$(ARCH)/asm/%.s, $(BUILD_DIR)/arch/$(ARCH)/asm/%.o, $(asm_src_files))

.PHONY: kernel iso

kernel: $(kernel_target)

$(kernel_target): $(asm_obj_files)
	@echo "[$(LD)] linking kernel-$(ARCH).bin"
	@$(LD) $(LD_FLAGS) -o $(kernel_target) $(asm_obj_files)

$(BUILD_DIR)/arch/$(ARCH)/asm/%.o: arch/$(ARCH)/asm/%.s
	@mkdir -p $(shell dirname $@)
	@echo "[$(AS)] $<"
	@$(AS) $(AS_FLAGS) $< -o $@

iso: $(iso_target)

$(iso_target): $(kernel_target)
	@echo "[grub] building ISO kernel-$(ARCH).iso"

	@mkdir -p $(BUILD_DIR)/isofiles/boot/grub
	@cp $(kernel_target) $(BUILD_DIR)/isofiles/boot/kernel.bin

	@cp arch/$(ARCH)/script/grub.cfg $(BUILD_DIR)/isofiles/boot/grub

	@grub-mkrescue -o $(iso_target) $(BUILD_DIR)/isofiles 2>&1 | sed -e "s/^/  | /g"
	@rm -r $(BUILD_DIR)/isofiles

run: iso
	qemu-system-i386 -d int,cpu_reset -no-reboot -cdrom build/kernel-x86.iso -boot order=dc

