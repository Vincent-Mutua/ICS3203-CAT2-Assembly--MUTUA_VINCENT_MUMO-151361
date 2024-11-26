section .data
    prompt db "Enter a number: ", 0
    pos_msg db "POSITIVE", 0
    neg_msg db "NEGATIVE", 0
    zero_msg db "ZERO", 0

section .bss
    num resb 4

section .text
    global _start

_start:
    ; Prompt for user input
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, 14
    int 0x80

    ; Read user input
    mov eax, 3
    mov ebx, 0
    mov ecx, num
    mov edx, 4
    int 0x80

    ; Convert input to integer
    mov esi, num
    call atoi

    ; Compare and classify number
    cmp eax, 0
    je .zero
    jl .negative
    jmp .positive

.positive:
    ; Output POSITIVE message
    mov eax, 4
    mov ebx, 1
    mov ecx, pos_msg
    mov edx, 8
    int 0x80
    jmp .exit

.negative:
    ; Output NEGATIVE message
    mov eax, 4
    mov ebx, 1
    mov ecx, neg_msg
    mov edx, 8
    int 0x80
    jmp .exit

.zero:
    ; Output ZERO message
    mov eax, 4
    mov ebx, 1
    mov ecx, zero_msg
    mov edx, 4
    int 0x80

.exit:
    ; Exit the program
    mov eax, 1
    xor ebx, ebx
    int 0x80

atoi:
    ; ASCII to integer conversion subroutine
    xor eax, eax
    xor ebx, ebx
    mov ecx, 10

atoi_loop:
    movzx edx, byte [esi]
    cmp edx, '0'
    jl atoi_done
    cmp edx, '9'
    jg atoi_done
    sub edx, '0'
    imul eax, ecx
    add eax, edx
    inc esi
    jmp atoi_loop
atoi_done:
    imul eax, edi ; Apply the sign
    ret
