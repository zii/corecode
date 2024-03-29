; vim: set ft=nasm :

section .multiboot_header

MAGIC equ 0xe85250d6
ARCH equ 0x0

; Define the multiboot header (multiboot 1.6)
; http://nongnu.askapache.com/grub/phcoder/multiboot.pdf
header_start:
	dd MAGIC                       ; magic number
	dd ARCH                        ; i386 protected mode
	dd header_end - header_start   ; header length

	; The field ‘checksum’ is a 32-bit unsigned value which, when added to the other
	; magic fields (i.e. ‘magic’, ‘architecture’ and ‘header_length’), must have a
	; 32-bit unsigned sum of zero.
	dd (1 << 32) - (MAGIC + ARCH + (header_end - header_start))

	align 8 ; tags should be 64-bit aligned

	; Define graphics mode tag
	;dw 5    ; type
	;dw 0    ; flags
	;dd 20   ; size
	;dd 80   ; width (pixels or chars)
	;dd 25   ; height (pixels or chars)
	;dd 0    ; bpp (0 for text mode

	align 8 ; tags should be 64-bit aligned

	; According to page 6 of the spec, the tag list is terminated by a tag with
	; type 0 and size 8
	dd 0    ; type & flag = 0
	dd 8    ; size
header_end: