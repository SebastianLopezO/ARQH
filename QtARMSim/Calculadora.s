	.data
str: .asciz "Operando: %d %c %d = %d\n"

.text
.global main

main:
    mov r0, #10    @ Primer término
    mov r1, #5     @ Segundo término
    mov r2, #'+'   @ Operador (+)
    bl sum         @ Llama a la función sumar


stop:
    wfi

sum:
    add r3, r0, r1    @ Realiza la suma y almacena el resultado en r3
    ldr r4, =str      @ Carga la dirección de la cadena de formato en r4
    mov r0, r3        @ Primer término
    mov r1, r2        @ Operador
    mov r2, r1        @ Segundo término
    mov r1, r3        @ Resultado
    bl printf         @ Llama a printf para imprimir el mensaje
