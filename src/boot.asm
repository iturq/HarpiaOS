%include "multiboot2.asm"

section .text
align 8

multiboot_header:
    dd      MULTIBOOT2_HEADER_MAGIC
    dd      MULTIBOOT_ARCHITECTURE_I386
    dd      multiboot_header_end - multiboot_header
    dd      -(MULTIBOOT2_HEADER_MAGIC + MULTIBOOT_ARCHITECTURE_I386 + (multiboot_header_end - multiboot_header))
align 8

; address_tag_start:
; ;tag_type
;     dw      MULTIBOOT_HEADER_TAG_ADDRESS
; ;tag_flags
;     dw      MULTIBOOT_HEADER_TAG_OPTIONAL
; ;tag_size
;     dd      address_tag_end - address_tag_start
; ;header_addr
;     dd      multiboot_header
; ;load_addr
;     dd      _start
; ;load_end_addr
;     dd      data_end
; ;bss_end_addr
;     dd      bss_end
; address_tag_end:

; align 8
; entry_address_tag_start:        
;     dw      MULTIBOOT_HEADER_TAG_ENTRY_ADDRESS
;     dw      MULTIBOOT_HEADER_TAG_OPTIONAL
;     dd      entry_address_tag_end - entry_address_tag_start
; ;entry_addr
;     dd      _start
; entry_address_tag_end:

; align 8
; framebuffer_tag_start:  
;     dw      MULTIBOOT_HEADER_TAG_FRAMEBUFFER
;     dw      MULTIBOOT_HEADER_TAG_OPTIONAL
;     dd      framebuffer_tag_end - framebuffer_tag_start
;     dd      1024
;     dd      768
;     dd      32
; framebuffer_tag_end:

align 8
    dw      MULTIBOOT_HEADER_TAG_END
    dw      0
    dd      8
multiboot_header_end:

global _start:function (_start.end - _start)
_start:
    mov    esp,    stack_top

    push   0
    popf

    push    ebx
    push    eax

    extern  halmain
    call    halmain

    cli
.halt:
    hlt
    jmp     .halt

.end:

section .data
align 16
data_start:
data_end:

section .bss
align 16
bss_start:
stack_botton:
    resb    16384
stack_top:
bss_end: