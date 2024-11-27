section .bss
    array resd 5       ; Reserve space for 5 integers
    buffer resb 10     ; Buffer for reading input

section .data
    prompt db "Enter 5 integers: ", 0
    reversed_msg db "Reversed array: ", 0
    newline db 0xA, 0
    space db ' ', 0

section .text
    global _start

_start:
    ; Print the prompt message
    mov rax, 1                  ; sys_write
    mov rdi, 1                  ; File descriptor (stdout)
    mov rsi, prompt             ; Pointer to the prompt message
    mov rdx, 34                 ; Length of the prompt message
    syscall

    ; Read input into buffer
    mov rax, 0                  ; sys_read
    mov rdi, 0                  ; File descriptor (stdin)
    mov rsi, buffer             ; Pointer to the buffer
    mov rdx, 10                 ; Number of bytes to read
    syscall

    ; Parse and store the integers in the array
    lea rsi, [buffer]           ; Load address of buffer into RSI
    lea rdi, [array]            ; Load address of array into RDI
    mov rcx, 5                  ; Loop counter for 5 integers

.read_loop:
    call read_integer           ; Read an integer from buffer
    mov [rdi], eax              ; Store the integer in the array
    add rdi, 4                  ; Move to the next array element
    loop .read_loop

    ; Reverse the array in place
    lea rdi, [array]            ; Load address of array into RDI (start pointer)
    lea rsi, [array + 4*4]      ; Load address of the last element into RSI (end pointer)

.reverse_loop:
    cmp rdi, rsi                ; Compare start and end pointers
    jge .done                   ; If start >= end, we're done

    ; Swap elements at RDI and RSI
    mov eax, [rdi]              ; Load element at start pointer into EAX
    mov ebx, [rsi]              ; Load element at end pointer into EBX
    mov [rdi], ebx              ; Store element from end to start
    mov [rsi], eax              ; Store element from start to end

    ; Move pointers towards the center
    add rdi, 4                  ; Move start pointer to the next element
    sub rsi, 4                  ; Move end pointer to the previous element
    jmp .reverse_loop           ; Repeat the loop

.done:
    ; Print the reversed array message
    mov rax, 1                  ; sys_write
    mov rdi, 1                  ; File descriptor (stdout)
    mov rsi, reversed_msg       ; Pointer to the reversed array message
    mov rdx, 16                 ; Length of the reversed array message
    syscall

    ; Output the reversed array
    lea rsi, [array]            ; Load address of array into RSI
    mov rcx, 5                  ; Loop counter

.output_loop:
    mov eax, [rsi]              ; Load element into EAX
    call print_integer          ; Print the integer
    add rsi, 4                  ; Move to the next array element

    ; Print a space between numbers
    mov rax, 1                  ; sys_write
    mov rdi, 1                  ; File descriptor (stdout)
    mov rsi, space              ; Pointer to the space character
    mov rdx, 1                  ; Length of the space character
    syscall

    loop .output_loop

    ; Print a newline
    mov rax, 1                  ; sys_write
    mov rdi, 1                  ; File descriptor (stdout)
    mov rsi, newline            ; Pointer to the newline character
    mov rdx, 1                  ; Length of the newline character
    syscall

    ; Exit the program
    mov rax, 60                 ; sys_exit
    xor rdi, rdi                ; Exit code 0
    syscall

; Subroutine to read an integer from buffer
read_integer:
    push rbx
    xor rax, rax
    mov rbx, 10
.convert:
    lodsb                       ; Load byte from buffer
    cmp al, ' '                 ; Check for space
    je .done_reading
    sub al, '0'                 ; Convert ASCII to integer
    imul rax, rbx               ; Multiply current result by 10
    add rax, rbx                ; Add new digit
    jmp .convert
.done_reading:
    pop rbx
    ret

; Subroutine to print an integer (assuming single digit for simplicity)
print_integer:
    push rbx
    mov ebx, 10
.convert_print:
    xor rdx, rdx
    div ebx                     ; RAX / 10
    add dl, '0'                 ; Convert to ASCII
    push rdx                    ; Push digit
    test rax, rax
    jnz .convert_print

.print_digits:
    pop rdx
    mov [rsp-1], dl             ; Store ASCII character on stack
    mov rax, 1                  ; sys_write
    mov rdi, 1                  ; File descriptor (stdout)
    lea rsi, [rsp-1]            ; Pointer to ASCII character
    mov rdx, 1                  ; Length of the ASCII character
    syscall
    test rsp, rsp
    jnz .print_digits

    pop rbx
    ret
