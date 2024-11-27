section .data
    sensor_value db 0        ; Simulated sensor value
    motor_status db 0        ; Motor status (0=off, 1=on)
    alarm_status db 0        ; Alarm status (0=off, 1=on)

section .text
    global _start

_start:
    ; Read the sensor value
    mov al, [sensor_value]   ; Load sensor value into AL

    ; Check the sensor value and take appropriate actions
    cmp al, 80               ; Compare sensor value with high threshold (example: 80)
    jg trigger_alarm         ; If sensor value > 80, trigger alarm

    cmp al, 50               ; Compare sensor value with moderate threshold (example: 50)
    jg stop_motor            ; If sensor value > 50, stop motor

    ; Turn on the motor for sensor values <= 50
    mov byte [motor_status], 1  ; Turn on the motor
    jmp end                  ; Jump to end

trigger_alarm:
    mov byte [alarm_status], 1  ; Trigger alarm
    jmp end                  ; Jump to end

stop_motor:
    mov byte [motor_status], 0  ; Stop the motor
    jmp end                  ; Jump to end

end:
    ; Exit the program
    mov rax, 60              ; sys_exit
    xor rdi, rdi             ; Exit code 0
    syscall
