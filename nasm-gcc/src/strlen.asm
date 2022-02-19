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
    push r13                ; save the initial value of r13
    xor r13, r13            ; make sure r13 is zeroed
.loop:
    cmp byte [rdi + r13], 0
    je .end
    inc r13
    jmp .loop
.end:
    mov rax, r13            ; move the return value to rax
    pop r13                 ; restore the original r13
    ret

_start:
    mov rdi, test_string
    call strlen
    ; TODO: print string lenght
    call print_newline
    mov rdi, rax

    mov rax, 60
    syscall