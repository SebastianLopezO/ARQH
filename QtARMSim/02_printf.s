	.data
str: .asciz "Operando: %d %c %d = %d"

	.text
main:
    mov r0, #5           @ Primer operando
    mov r1, #'+'         @ Operador (en este caso, suma)
    mov r2, #3           @ Segundo operando
    mov r5, #8           @ Almacena el resultado en r3

    sub sp, sp, #16      @ Reserva espacio para cuatro palabras (4 * 4 bytes = 16 bytes) en la pila
    str r0, [sp,#16]         @ Almacena el resultado en la pila
    str r2, [sp, #4]     @ Almacena el segundo operando en la pila
    str r5, [sp, #8]     @ Almacena el operador en la pila
    str r1, [sp, #12]    @ Almacena el primer operando en la pila

    mov r0, #0           @ Columna para PrintF
    mov r1, #0           @ Fila para PrintF
    ldr r2, =str         @ Carga la dirección de la cadena de formato en r2
    bl printf            @ Llama a printf para imprimir la cadena formateada

    add sp, sp, #16      @ Restaura el puntero de pila después de usarla

stop: wfi
