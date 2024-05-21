%include "multiboot2.asm"
%include "x86_64.asm"

section .text
BITS 32
align 8

extern  high_base_addr

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
    cli
    mov     esp, stack_top
    push    0
    popf
    
    push    ebx
    push    eax

    mov     eax, 0x80000000
    cpuid
    cmp     eax, 0x80000000
    jbe     error.nolong
    
    mov     eax, 0x80000001
    cpuid
    test    edx, 1 << 29
    jz      error.nolong

    ;OK there is long mode

    mov     eax, 0x1
    cpuid
    test    edx, 1 << 25
    jz      error.nosse

    ;OK there is SSE

    ;Enable SSE
    mov     eax, cr0
    and     eax, ~CR0_EM
    or      eax, CR0_MP
    mov     cr0, eax

    ;Enable PAE and SSE
    mov     eax, cr4
    or      eax, CR4_PAE | CR4_OSFXSR | CR4_OSXMMEXCPT
    mov     cr4, eax

    ;Enable Long mode
    mov     ecx, EFER_ADDRESS               ;MSR EFER - Extended Feature Enable Register
    rdmsr
    or      eax, EFER_LONG_MODE_ENABLE
    wrmsr

    ;Setup Page
    mov     edi, pml4t
    xor     eax, eax
    mov     ecx, 0x600                      ;clear 3 page tables
    rep     stosd
    mov     edi, pml4t
    mov     eax, pdpt
    or      eax, PML4E_LOW_PRESENT | PML4E_LOW_READ_WRITE
    mov     [edi], eax              ;VMA = 0x0000_0000_0000_0000
    mov     [edi + 0x2*8], eax      ;VMA = 0x0000_0100_0000_0000    High kernel map 1 TB addr
    
;    mov     eax, 0x80000001
;    cpuid
;    test    edx, 1 << 26    ;test 1GB page support
;    jz      .page2mb

;.page1gb:
;    mov     edi, pdpt
;    mov     eax, PDPTE_1GB_LOW_PAGE_SIZE | PDPTE_1GB_LOW_PRESENT | PDPTE_1GB_LOW_READ_WRITE
;    xor     ecx, ecx
;    xor     edx, edx
;.setpage1gb:
;    mov     edx, ecx
;    shl     edx, 30
;    or      edx, eax
;    mov     [edi], edx
;    mov     edx, ecx
;    shr     edx, 2
;    mov     [edi + 4], edx
;    add     edi, 8
;    inc     ecx
;    cmp     ecx, 1
;    jne     .setpage1gb
;
;    jmp     .setpagecomplete

.page2mb:
;    mov     eax, msgno1gb
;    call    puts

    mov     edi, pdpt
    mov     eax, pde
    or      eax, PDPTE_LOW_PRESENT | PDPTE_LOW_READ_WRITE
    mov     [edi], eax

    mov     edi, pde
    mov     eax, PDE_2MB_LOW_PAGE_SIZE | PDE_2MB_LOW_PRESENT | PDE_2MB_LOW_READ_WRITE
    xor     ecx, ecx
    xor     edx, edx
.setpage2mb:
    mov     edx, ecx
    shl     edx, 21
    or      edx, eax
    mov     [edi], edx
    mov     edx, ecx
    shr     edx, 11
    mov     [edi + 4], edx
    add     edi, 8
    inc     ecx
    cmp     ecx, 512
    jne     .setpage2mb

.setpagecomplete:

    ;Enable Paging
    mov     eax, pml4t
    mov     cr3, eax

    mov     ebx, cr0
    or      ebx, CR0_PG | CR0_PE
    mov     cr0, ebx

;    jmp dword gdt64.Code:.long32             ; Load CS with 64 bit segment and flush the instruction cache
;    jmp [gdt64.Code]:.longmode

.long32:
    pop     eax
    pop     ebx
  
    lgdt    [gdt64.Pointer]                ; Load GDT.Pointer defined below.
    jmp     dword gdt64.Code64Ker:.long64

BITS 64
.long64:
    mov     cx, gdt64.Data64Ker
    mov     ds, cx

    mov     rdx, high_base_addr

    lgdt    [gdt64.Pointer]

;    push    gdt64.Code64Ker
;    lea     rsi, [.longhigh64]
;    push    rsi
;    retf                                   ;far return to longhigh64

.longhigh64:
    
    mov     rdi, stack_botton
    add     rdi, rdx
    fxsave  [rdi]

    mov     cx, gdt64.Data64Ker
    mov     ds, cx
    mov     es, cx
    mov     fs, cx
    mov     gs, cx
    mov     ss, cx

    mov     rcx, .highmem64
    add     rcx, rdx
    call    rcx
.highmem64:
    mov     rcx, stack_top
    add     rcx, rdx
    mov     rsp, rcx
    push    0

    mov     rdi, pml4t
    add     rdi, rdx
    xor     rcx, rcx
    mov     [rdi], rcx

    extern base_address
    extern top_address
    mov     rdi, rax            ;rdi - multiboot2 magic number
    mov     rsi, rbx            ;rsi - multiboot2 structure address
    add     rsi, rdx            ;rdx - high memory page map : 1TB
    mov     rcx, base_address   ;rcx - kernel base address
    mov     r8, top_address     ;r8 - kernel top address
                                ;all addresses mapped to 1TB
    extern  kmain
    mov     rax, kmain
    call    rax
;    mov     rcx, halmain
;    push    gdt64.Code
;    push    rcx
;    call    far [rsp]

.halt:
    cli
.haltloop:
    hlt
    jmp     .haltloop

.end:

BITS 32
error:
.nolong:
    mov     eax, msgnolong
    call    puts
    jmp     halt

.nosse:
    mov     eax, msgnosse
    call    puts
    jmp     halt

halt:
    cli
.haltloop:
    hlt
    jmp     .haltloop

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
msgnosse    db      "No SEE Detected",10,0
msgno1gb    db      "No 1GB page support.",10,"Using 2MB page only.",0

align 16
; Global Descriptor Table
gdt64:
.Null:          equ $ - gdt64
    dq      0x0000000000000000              ; Null Descriptor - should be present.

.Code64Ker:     equ $ - gdt64
;bits used  0x0060_E400_0000_0000
    dq      0x00AF_9800_0000_FFFF           ; 64-bit code descriptor (exec/read).

.Code64Dev:     equ $ - gdt64
;bits used  0x0060_E400_0000_0000
;    dq      0x0020_9A00_0000_0000             
    dq      0x00AF_B800_0000_FFFF           ; 64-bit code descriptor (exec/read).

.Code64Srv:     equ $ - gdt64
;bits used  0x0060_E400_0000_0000
;    dq      0x0020_9A00_0000_0000
    dq      0x00AF_D800_0000_FFFF           ; 64-bit code descriptor (exec/read).

.Code64Usr:     equ $ - gdt64
;bits used  0x0060_E400_0000_0000
;    dq      0x0020_9A00_0000_0000             ; 64-bit code descriptor (exec/read).
    dq      0x00AF_F800_0000_FFFF 

.Data64Ker:     equ $ - gdt64
;    dq      0x0020_9200_0000_0000
    dq      0x00AF_9200_0000_FFFF             ; 64-bit data descriptor (read/write).

.Data64Dev:     equ $ - gdt64
;    dq      0x0020_9200_0000_0000
    dq      0x00AF_B200_0000_FFFF             ; 64-bit data descriptor (read/write).
    
.Data64Srv:     equ $ - gdt64
;    dq      0x0020_9200_0000_0000
    dq      0x00AF_D200_0000_FFFF             ; 64-bit data descriptor (read/write).
    
.Data64Usr:     equ $ - gdt64
;    dq      0x0020_9200_0000_0000
    dq      0x00AF_F200_0000_FFFF             ; 64-bit data descriptor (read/write).

;.Code32Dev:     equ $ - gdt64
;    dq      0x00CF_B800_0000_FFFF
;
;.Code32Srv:     equ $ - gdt64
;    dq      0x00CF_D800_0000_FFFF
;   
;.Code32Usr:     equ $ - gdt64
;    dq      0x00CF_F800_0000_FFFF
;
;.Data32Dev:     equ $ - gdt64
;    dq      0x00CF_B200_0000_FFFF
;
;.Data32Srv:     equ $ - gdt64
;    dq      0x00CF_D200_0000_FFFF
;
;.Data32Usr:     equ $ - gdt64
;    dq      0x00CF_F200_0000_FFFF
;
;.Code16Dev:     equ $ - gdt64
;    dq      0x008F_B800_0000_FFFF
;
;.Code16Srv:     equ $ - gdt64
;    dq      0x008F_D800_0000_FFFF
;
;.Code16Usr:     equ $ - gdt64
;    dq      0x008F_F800_0000_FFFF
;
;.Data16Dev:     equ $ - gdt64
;    dq      0x008F_B200_0000_FFFF
;
;.Data16Srv:     equ $ - gdt64
;    dq      0x008F_D200_0000_FFFF
;
;.Data16Usr:     equ $ - gdt64
;    dq      0x008F_F200_0000_FFFF
.Tss:   equ - $ - gdt64
    dd      0x0000_0000
    dd      0x0000_0000

ALIGN 4
    dw      0                              ; Padding to make the "address of the GDT" field aligned on a 4-byte boundary

.Pointer:
    dw      $ - gdt64 - 1                    ; 16-bit Size (Limit) of GDT.
    dd      gdt64
    dd      0x0000_0100

data_end:

section .bss
align 16
bss_start:
stack_botton:
    resb    16384
stack_top:
pml4t:
    resb    4096
pdpt:
    resb    4096
pde:
    resb    4096
;pt:
;    resb    8192
bss_end: