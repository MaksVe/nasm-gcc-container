; output rax value in hexadecimal format

; nasm -felf64 print_rax.asm -o print_rax.o
; ld -o print_rax.out print_rax.o
; chmod u+x print_rax.out
; ./print_rax.out

section .data
codes:
    db '0123456789ABCDEF'

section .text
global _start
_start:
    ; number 1122... in hexadecimal format
    mov rax, 0x1122334455667788

    mov rdi, 1 ; arg#1: where to write (descriptor)
    mov rdx, 1
    mov rcx, 64
    ; Each 4 bits should be output as one hexadecimal digit
    ; Use shift and bitwise AND to isolate them
    ; the result is the offset in 'codes' array
.loop:
    push rax
    sub rcx, 4
    ; cl is a register, smallest part of rcx
    ; rax -- eax -- ax -- ah + al
    ; rcx -- ecx -- cx -- ch - cl
    sar rax, cl
    and rax, 0xf

    ; about lea rsi, [codes + rax]
    ; square brackets denote indirect addressing; the address is written inside them
    ; mov rsi, rax - copies rax into rsi
    ; mov rsi, [rax] - copies memory contents (8 sequential bytes) starting at address
    ; stored in rax into rsi (rsi is 8 bytes long)
    
    ; lea means "load effective address". It allows to calculate an address of a memory cell
    ; and store it somewhere

    ; equivalent of combination:
    ; -- mov rsi, codes
    ; -- add rsi, rax
    lea rsi, [codes + rax]
    mov rax, 1

    ;syscall leaves rcx and r11 changed
    push rcx
    syscall
    pop rcx

    pop rax
    ; test can be used for the fastest 'is it a zero?' check
    ; see docs for 'test' command
    test rcx, rcx
    jnz .loop
    
    ; 'exit' system call
    mov rax, 60
    xor rdi, rdi
    syscall