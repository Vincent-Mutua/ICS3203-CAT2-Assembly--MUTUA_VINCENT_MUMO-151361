section .data
    prompt db "Enter a number: ", 0
    result_msg db "Factorial: ", 0
    newline db 0xA, 0

section .bss
    num resb 4        ; Reserve space for the input number
    result resb 20    ; Buffer to store the factorial result as a string

section .text
    global _start

_start:
    ; Print the prompt message
    mov rax, 1                  ; sys_write
    mov rdi, 1                  ; File descriptor (stdout)
    mov rsi, prompt             ; Pointer to the prompt message
    mov rdx, 16                 ; Length of the prompt message
    syscall

    ; Read input number
    mov rax, 0                  ; sys_read
    mov rdi, 0                  ; File descriptor (stdin)
    mov rsi, num                ; Pointer to the buffer
    mov rdx, 4                  ; Number of bytes to read
    syscall

    ; Convert input to integer
    mov rsi, num
    xor rax, rax
    xor rcx, rcx
.convert_loop:
    movzx rbx, byte [rsi + rcx] ; Load each character
    cmp rbx, 0xA                ; Check for newline
    je .convert_done
    sub rbx, '0'                ; Convert ASCII to integer
    imul rax, rax, 10           ; Multiply previous result by 10
    add rax, rbx                ; Add current digit
    inc rcx                     ; Move to the next character
    jmp .convert_loop
.convert_done:

    ; Call the factorial subroutine
    push rax                    ; Push the number onto the stack
    call factorial
    add rsp, 8                  ; Clean up the stack

    ; Convert the result to a string
    mov rsi, result             ; Pointer to the result buffer
    call uint_to_string         ; Convert RAX (factorial result) to a string
    mov rdx, rbx                ; Retrieve the string length from uint_to_string

    ; Print the result message
    mov rax, 1                  ; sys_write
    mov rdi, 1                  ; File descriptor (stdout)
    mov rsi, result_msg         ; Pointer to the result message
    mov rdx, 10                 ; Length of the result message
    syscall

    ; Print the factorial result
    mov rax, 1                  ; sys_write
    mov rdi, 1                  ; File descriptor (stdout)
    mov rsi, rsi                ; Pointer to the result string (set by uint_to_string)
    syscall

    ; Print a newline
    mov rax, 1                  ; sys_write
    mov rdi, 1                  ; File descriptor (stdout)
    mov rsi, newline            ; Pointer to the newline character
    mov rdx, 1                  ; Length of the newline character
    syscall

    ; Exit the program
    mov rax, 60                 ; sys_exit
    xor rdi, rdi
    syscall

; Factorial subroutine
factorial:
    push rbp                    ; Save base pointer
    mov rbp, rsp                ; Set stack frame
    sub rsp, 8                  ; Allocate space for local variable

    mov rax, [rbp+16]           ; Get the input number (passed via stack)
    cmp rax, 1
    jle .base_case

    dec rax
    push rax
    call factorial
    pop rbx
    imul rax, rbx
    jmp .end

.base_case:
    mov rax, 1

.end:
    mov rsp, rbp                ; Restore stack
    pop rbp                     ; Restore base pointer
    ret

; Subroutine to convert unsigned integer to string
uint_to_string:
    push rbx
    push rcx
    xor rbx, rbx                ; Clear RBX (used for storing the result length)
    mov rcx, 10                 ; Divisor for base 10

    lea rsi, [rsi + 20]         ; Start from the end of the buffer
.convert:
    xor rdx, rdx
    div rcx                     ; RAX = RAX / 10, RDX = RAX % 10
    add dl, '0'
    dec rsi
    mov [rsi], dl
    inc rbx
    test rax, rax
    jnz .convert

    ; Return result length and pointer to the main program
    pop rcx
    pop rbx
    ret
