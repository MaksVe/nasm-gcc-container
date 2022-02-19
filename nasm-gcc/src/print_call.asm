; nasm -felf64 print_call.asm -o print_call.o
; ld -o print_call.out print_call.o
; chmod u+x print_call.out
; ./print_call.out

section .data

newline_char: db 10
codes: db '0123456789ABCDEF'

section .text
global _start

print_newline:
    mov rax, 1              ; 'write' system call identifier
    mov rdi, 1              ; sdout file descriptor
    mov rsi, newline_char   ; where do we take data from
    mov rdx, 1              ; the amout of bytes to write
    syscall
    ret

print_hex:
    mov rax, rdi
    mov rdi, 1
    mov rdx, 1
    mov rcx, 64             ; how far we are shifting rax
iterate:
    push rax                ; save the initial rax value
    sub rcx, 4              
    sar rax, cl             ; shift to 60, 56, 52, .. 4, 0
    and rax, 0xf            ; clear all bits but the lowest four
    lea rsi, [codes + rax]  ; take a hexadecimal digit character code

    mov rax, 1

    push rcx                ; syscall will break rcx
    syscall                 ; rax = 1 (31) -- the write identifier,
                            ; rdi = 1 for stdout,
                            ; rsi = the address of a character, see line 29
    pop rcx

    pop rax                 ; see line 24
    test rcx, rcx           ; rcx = 0 whel all digits are shown
    jnz iterate

    ret

_start:
    mov rdi, 0x1122334455667788
    call print_hex
    call print_newline

    mov rax, 60
    xor rdi, rdi
    syscall