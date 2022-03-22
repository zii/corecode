; vim: set ft=nasm :

section .bss
align 4

; Reserve 16K for our stack. Stacks should be aligned to 16 byte boundaries.
stack_bottom:
    resb 16384 	; 16 KiB
stack_top:

; According to the "ELF handling for TLS" document section 4.3.2
; (https://www.akkadia.org/drepper/tls.pdf) for the GNU variant of the IA-32 ABI,
; gs:0x00 contains a pointer to the TCB. Variables in the TLS are stored
; before the TCB and are accessed using negative offsets from the TCB address.
g0_ptr:	        resd 1
tcb_ptr:        resd 1

section .text
bits 32
align 4

MULTIBOOT_MAGIC equ 0x36d76289

G_STACK_LO equ 0x0
G_STACK_HI equ 0x4
G_STACKGUARD0 equ 0x8

hello_world db 'hello world!', 0
err_unsupported_bootloader db '[rt0] kernel not loaded by multiboot-compliant bootloader', 0

tmp_multiboot_info dw 0

;------------------------------------------------------------------------------
; Kernel arch-specific entry point
;
; The boot loader will jump to this symbol after setting up the CPU according
; to the multiboot standard. At this point:
; - A20 is enabled
; - The CPU is using 32-bit protected mode
; - Interrupts are disabled
; - Paging is disabled
; - EAX contains the magic value ‘0x36d76289’; the presence of this value indicates
;   to the operating system that it was loaded by a Multiboot-compliant boot loader
; - EBX contains the 32-bit physical address of the Multiboot information structure
;------------------------------------------------------------------------------
global _rt0_entry
_rt0_entry:
    cmp eax, MULTIBOOT_MAGIC
    jne unsupported_bootloader

    mov [tmp_multiboot_info], ebx

    ; Initalize our stack by pointing ESP to the BSS-allocated stack. In x86,
    ; stack grows downwards so we need to point ESP to stack_top
    mov esp, stack_top

    mov edi, hello_world
    call write_string

    ; Main should never return; halt the CPU
halt:
    cli
    hlt

unsupported_bootloader:
    mov edi, err_unsupported_bootloader
    call write_string
    jmp halt
.end:

;------------------------------------------------------------------------------
; Write the NULL-terminated string contained in edi to the screen using white
; text on red background.  Assumes that text-mode is enabled and that its
; physical address is 0xb8000.
;------------------------------------------------------------------------------
write_string:
    push eax
    push ebx

    mov ebx,0xb8000
    mov ah, 0x4F
next_char:
    mov al, byte[edi]
    test al, al
    jz done

    mov word [ebx], ax
    add ebx, 2
    inc edi
    jmp next_char

done:
    pop ebx
    pop eax
    ret
