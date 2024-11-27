section .data
    prompt db "Enter a number: ", 0
    pos_msg db "POSITIVE", 0
    neg_msg db "NEGATIVE", 0
    zero_msg db "ZERO", 0

section .bss
    num resb 10   ; Reserve enough space for up to 10 characters (including newline)

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
    mov edx, 10
    int 0x80

    ; Remove newline character if present
    mov esi, num           ; Start of input
    mov ecx, 10            ; Maximum length of input
    xor edi, edi           ; Index for loop
remove_newline:
    cmp byte [esi + edi], 10 ; Check for newline '\n'
    je null_terminate        ; Replace newline with null terminator
    cmp byte [esi + edi], 0  ; Check for null terminator
    je null_terminate        ; End of input
    inc edi                  ; Move to the next character
    loop remove_newline
null_terminate:
    mov byte [esi + edi], 0  ; Null-terminate the string

    ; Convert input to integer
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
    ; ASCII to integer conversion subroutine with sign handling
    xor eax, eax           ; Clear EAX for the result
    xor ebx, ebx           ; Clear EBX (used for the sign)
    mov ecx, 10            ; Base 10
    xor edi, edi           ; Clear EDI (used for sign: 0 = positive, 1 = negative)

    ; Check for a negative sign
    movzx edx, byte [esi]  ; Load the first character
    cmp edx, '-'           ; Check if it's a '-'
    jne check_digit         ; If not '-', skip to check_digit
    inc esi                ; Move to the next character
    mov edi, 1             ; Set sign to negative

check_digit:
atoi_loop:
    movzx edx, byte [esi]  ; Load the current character
    cmp edx, '0'           ; Check if it's less than '0'
    jl atoi_done
    cmp edx, '9'           ; Check if it's greater than '9'
    jg atoi_done
    sub edx, '0'           ; Convert ASCII to integer
    imul eax, ecx          ; Multiply result by 10
    add eax, edx           ; Add the current digit to the result
    inc esi                ; Move to the next character
    jmp atoi_loop          ; Repeat until non-digit is encountered

atoi_done:
    test edi, edi          ; Check if the number is negative
    jz atoi_return         ; If positive, skip
    neg eax                ; Make the result negative

atoi_return:
    ret
