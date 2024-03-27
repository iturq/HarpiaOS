%include "multiboot2.asm"
%include "x86_64.asm"

section .text
BITS 32
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
    mov     esp,    stack_top
    push    0
    popf
    
    push    ebx
    push    eax

    mov     eax, 0x80000000
    cpuid
    cmp     eax, 0x80000000
    jbe     nolong
    
    mov     eax, 0x80000001
    cpuid
    test    edx, 1 << 29
    jz      nolong

    ;OK there is long mode
 
    ;Enable PAE
    mov     eax, cr4
    or      eax, CR4_PAE
    mov     cr4, eax

    ;Enable Long mode
    mov     ecx, 0xC0000080
    rdmsr
    or      eax, (1 << 8)
    wrmsr

    ;Setup Page
    mov     edi, pml4t
    xor     eax, eax
    mov     ecx, 0x8000
    rep     stosd
    mov     edi, pml4t
    mov     eax, pdpt
    or      eax, PML4E_LOW_PRESENT | PML4E_LOW_READ_WRITE
    mov     [edi], eax

    mov     edi, pdpt
    mov     eax, pde
    or      eax, PDPTE_LOW_PRESENT | PDPTE_LOW_READ_WRITE
    mov     [edi], eax

    mov     edi, pde
    mov     eax, PDE_2MB_LOW_PAGE_SIZE | PDE_2MB_LOW_PRESENT | PDE_2MB_LOW_READ_WRITE
    xor     ecx, ecx
.setpage:
    mov     [edi], eax
    add     edi, 8
    add     eax, 0x200000
    add     ecx, 2
    cmp     ecx, 10
    jne     .setpage

    ;Enable Paging
    mov     eax, pml4t
    mov     cr3, eax
    or      ebx, CR0_PG | CR0_PE
    mov     cr0, ebx

    jmp dword 0x10:.long32             ; Load CS with 64 bit segment and flush the instruction cache
;    jmp [gdt64.Code]:.longmode

;    mov     ax, datasel
;    mov     ds, ax
;    mov     es, ax
;    mov     fs, ax
;    mov     gs, ax

    ;jmp     codesel:.longmode

.long32:
    pop     eax
    pop     ebx
    
    lgdt    [gdt64.Pointer]                ; Load GDT.Pointer defined below.
    jmp     dword 0x8:.long64

BITS 64
.long64:
    mov     cx, 0x10
    mov     ds, cx
    mov     es, cx
    mov     fs, cx
    mov     gs, cx
    mov     ss, cx

    mov     rdi, rax
    mov     rsi, rbx

    extern  halmain
    call    halmain

    cli
.halt:
    hlt
    jmp     .halt

.end:

BITS 32
nolong:
    mov     eax, msgnolong
    call    puts
    cli
.halt:
    hlt
    jmp     .halt

;puts function
;   input   reg eax - string addr
puts:
    push    ebx
    mov     ebx, eax
.loop:
    mov     al, [ebx]
    cmp     al, 0
    je      .outloop
    call    putchar
    inc     ebx
    jmp     .loop
.outloop:
    pop     ebx
    ret

;putchar function
;   input   reg al  -   character to output
putchar:
    push    ecx
    mov     ch, [curx]
    mov     cl, [cury]
    cmp     al, 10      ;10 = '\n'
    jne     .cnt
    mov     ch, 0
    inc     cl
    jmp     .save
.cnt:
    push    ebx
    push    edx
    push    eax
    mov     bh, [width]
    mov     bl, [height]
    xor     edx, edx
    mov     dl, ch
    xor     eax, eax
    mov     al, bh
    mul     cl
    add     edx, eax
    shl     edx, 1
    add     edx, [video]
    pop     eax
    mov     [edx], al
    inc     ch
    cmp     ch, bh
    jne     .neq
    mov     ch, 0
    inc     cl
.neq:
    pop     edx
    pop     ebx
.save:
    mov     [cury], cl
    mov     [curx], ch
    pop     ecx
    ret

section .data
align 16
data_start:
video       dd      0xB8000
width       db      80
height      db      25
curx        db      0
cury        db      0
msgnolong   db      "No Long Mode Detected.",10,0

align 16
; Global Descriptor Table
gdt64:
.Null:
    dq      0x0000000000000000             ; Null Descriptor - should be present.

.Code:
    dq      0x00209A0000000000             ; 64-bit code descriptor (exec/read).
    dq      0x0020920000000000             ; 64-bit data descriptor (read/write).

ALIGN 4
    dw      0                              ; Padding to make the "address of the GDT" field aligned on a 4-byte boundary

.Pointer:
    dw      $ - gdt64 - 1                    ; 16-bit Size (Limit) of GDT.
    dd      gdt64
data_end:

section .bss
align 16
bss_start:
stack_botton:
    resb    16384
stack_top:
pml4t:
    resb    8192
pdpt:
    resb    8192
pde:
    resb    8192
pt:
    resb    8192
bss_end: