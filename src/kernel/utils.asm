
section .text
BITS 64
align 8

;extern void interruptenable()
global interruptenable:function (interruptenable.end - interruptenable)
interruptenable:
    sti
    ret
.end:

;extern void interruptdisable()
global interruptdisable:function (interruptdisable.end - interruptdisable)
interruptdisable:
    cli
    ret
.end:

;extern uint64_t readcr0()
global readcr0:function (readcr0.end - readcr0)
readcr0:
    mov     rax, cr0
    ret
.end:

;extern uint64_t readcr2()
global readcr2:function (readcr2.end - readcr2)
readcr2:
    mov     rax, cr2
    ret
.end:

;extern uint64_t readcr3()
global readcr3:function (readcr3.end - readcr3)
readcr3:
    mov     rax, cr3
    ret
.end:

;extern uint64_t readcr4()
global readcr4:function (readcr4.end - readcr4)
readcr4:
    mov     rax, cr4
    ret
.end:

;extern uint64_t readcr8()
global readcr8:function (readcr8.end - readcr8)
readcr8:
    mov     rax, cr8
    ret
.end:

;extern void writecr0(uint64_t flags)
global writecr0:function (writecr0.end - writecr0)
writecr0:
    mov     cr0, rdi
    ret
.end:

;extern void writecr2(uint64_t flags)
global writecr2:function (writecr2.end - writecr2)
writecr2:
    mov     cr2, rdi
    ret
.end:

;extern void writecr3(uint64_t pageaddress)
global writecr3:function (writecr3.end - writecr3)
writecr3:
    mov     cr3, rdi
    ret
.end:

;extern void writecr3(uint64_t pageaddress)
global writecr4:function (writecr4.end - writecr4)
writecr4:
    mov     cr4, rdi
    ret
.end:

;extern void writecr3(uint64_t pageaddress)
global writecr8:function (writecr8.end - writecr8)
writecr8:
    mov     cr8, rdi
    ret
.end:

;extern int memcmp(const void *ptr1, const void * ptr2, int num)
global memcmp:function (memcmp.end - memcmp)
memcmp:
    push    rdi
    push    rsi
    xor     rax, rax
    xor     rcx, rcx

.loop:
    cmp     rcx, rdx
    je      .loopend
    mov     r8b, [rdi]
    mov     r9b, [rsi]
    cmp     r8b, r9b
    jae      .grt

.les:
    dec     rax
    jmp     .loopend
.grt:
    cmp     r8b, r9b
    je      .continue
    inc     rax
    jmp     .loopend

.continue:
    inc     rcx
    inc     rdi
    inc     rsi
    jmp     .loop
.loopend:

    pop     rsi
    pop     rdi
    ret
.end:

;extern void* memcpy(void * destination, const void * source, int num)
global memcpy:function (memcpy.end - memcpy)
memcpy:
    push    rdi
    push    rsi
    xor     rcx, rcx

.loop:
    cmp     rcx, rdx
    je      .loopend
    mov     r8b, [rdi]
    mov     [rsi], r8b
    inc     rcx
    inc     rdi
    inc     rsi
    jmp     .loop
.loopend:

    pop     rsi
    pop     rdi
    ret
.end:

;extern void* memmove(void * destination, const void * source, int num);
global memmove:function (memmove.end - memmove)
memmove:
    push    rdi
    push    rsi

    cmp     rdi, rsi
    jae     .grteq

    xor     rcx, rcx
.loop1:
    cmp     rcx, rdx
    je      .loopend
    mov     r8b, [rdi]
    mov     [rsi], r8b
    inc     rcx
    inc     rdi
    inc     rsi
    jmp     .loop1

.grteq:
    mov     rcx, rdx
    dec     rdi
    dec     rsi
.loop2:
    cmp     rcx, 0
    je      .loopend
    mov     r8b, [rdi]
    mov     [rsi], r8b
    dec     rcx
    dec     rdi
    dec     rsi
    jmp     .loop2

.loopend:

    pop     rsi
    pop     rdi
    ret
.end:

;extern void* memset(void * ptr, int value, int num);
global memset:function (memset.end - memset)
memset:
    push    rdi
    xor     rcx, rcx

.loop:
    cmp     rcx, rdx
    je      .loopend
    mov     [rdi], sil
    inc     rcx
    inc     rdi
    jmp     .loop
.loopend:

    pop     rdi
    ret
.end:

;extern int strlen(const char * str);
global strlen:function (strlen.end - strlen)
strlen:
    xor     rax, rax
    xor     rdx, rdx
.loop:
    mov     dl, [rdi]
    cmp     dl, 0
    je      .loopend
    inc     rax
    inc     rdi
    jmp     .loop
.loopend:
    ret
.end:

;rdi    gdt pointer
;rsi    code selector
;rax    data selector
global gdtload:function (gdtload.end - gdtload)
gdtload:

    lgdt    [rdi]                ; Load GDT.Pointer defined below.
;    jmp     dword rsi:.long64
.long64:
    mov     cx, ax
    mov     ds, cx
    mov     es, cx
    mov     fs, cx
    mov     gs, cx
    mov     ss, cx

    ret
.end: