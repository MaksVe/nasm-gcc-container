global _start

section .data

newline_char: db 10
test_string: db "abcdef", 0

section .text

print_newline:
    mov rax, 1
    mov rdi, 1
    mov rsi, newline_char
    mov rdx, 1
    syscall
    ret

strlen:
.loop:
    cmp byte [rdi + r13], 0
    je .end
    inc r13
    jmp .loop
.end:
    mov rax, r13
    ret

_start:
    mov rdi, test_string
    call strlen
    ; TODO: print string lenght
    call print_newline
    mov rdi, rax

    mov rax, 60
    syscall