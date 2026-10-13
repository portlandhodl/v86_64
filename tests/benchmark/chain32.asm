; Cross-module chaining probe (32-bit): 9 code pages, each holding one tiny
; function, called in a round-robin loop. Every call/ret crosses a compiled
; module boundary (MAX_PAGES=3 < 9 pages), so with chaining on almost every
; call/ret is a return_call_indirect between modules. Assembled to a flat BIOS
; image; stores nothing, prints 'K' on serial when done. See chain32.js.

%ifndef ITERATIONS
%define ITERATIONS 200000
%endif

org 0xF0000

[bits 16]
start16:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7000

    a32 lgdt [gdt_ptr]
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    o32 jmp 0x08:pm32

align 8
gdt:
    dq 0
    dq 0x00CF9A000000FFFF           ; 0x08: 32-bit code
    dq 0x00CF92000000FFFF           ; 0x10: data
gdt_ptr:
    dw gdt_ptr - gdt - 1
    dd gdt

[bits 32]
pm32:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov esp, 0x80000

    ; copy the payload (page-aligned in this file) to 0x100000
    mov esi, workload_start
    mov edi, 0x100000
    mov ecx, workload_end - workload_start
    rep movsb
    jmp 0x100000

align 4096
workload_start:

; each function lives in its own page: align 4096 keeps file offset == rom
; address aligned, and the copied address 0x100000 keeps the alignment
main32:
    mov ebp, ITERATIONS
.outer:
    call f0
    call f1
    call f2
    call f3
    call f4
    call f5
    call f6
    call f7
    dec ebp
    jnz .outer

    mov dx, 0x3F8
    mov al, 'K'
    out dx, al
.halt:
    hlt
    jmp .halt

%macro FUNC 1
align 4096
%1:
    inc dword [0x508]
    ret
%endmacro

FUNC f0
FUNC f1
FUNC f2
FUNC f3
FUNC f4
FUNC f5
FUNC f6
FUNC f7

align 16
workload_end:

    times 0x10000 - 16 - ($ - $$) db 0
[bits 16]
reset:
    jmp 0xF000:start16
    times 0x10000 - ($ - $$) db 0
