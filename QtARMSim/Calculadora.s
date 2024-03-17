	.data
str: 	.asciz "Operando: %d %c %d = %d"

	.text
main:
    @ Ingresar operandos y operador manualmente
    mov r0,#'n'
    mov r1,#'n'
    mov r2,#'o'
    
    cmp r2,#'+'
    beq sum
    	cmp r2,#'-'
	beq subtract
		cmp r2,#'*'
		beq multiply
			cmp r2,#'/'
			beq divide
				@ Finalizar el programa
    				mov r0, #0
    				bx lr
		            @ Llama a la subrutina sum
  
    bl print_result    @ Imprime el resultado

    @ Finalizar el programa
    mov r0, #0
    bx lr

sum:
    	add r3, r0, r1     @ Suma los operandos
   	bx lr              @ Retorna

subtract:
	sub r3, r0, r1     @ Resta el segundo operando al primero
	bx lr              @ Retorna

multiply:
    mov r3,r0
    mul r3, r1     @ Multiplica los operandos
    bx lr              @ Retorna

divide:
    mov r4,r0
    mov r5,r1
    bl sdivide
    mov r3,r0
    mov r0,r4
    mov r1,r5
    bx lr              @ Retorna

print_result:
    sub sp, sp, #16      @ Reserva espacio para cuatro palabras (4 * 4 bytes = 16 bytes) en la pila
    str r3, [sp, #8]     @ Almacena el resultado dos words adelante del stack pointer
    str r1, [sp, #4]     @ Almacena el segundo termino una word adelante del stack pointer
    str r2, [sp]         @ Almacena el operador en la word del stack pointer
    mov r3, r0		 @ Almacena el primer termino una word antes del stack pointer

    mov r0, #0           @ Columna para PrintF
    mov r1, #0           @ Fila para PrintF
    ldr r2, =str         @ Carga la dirección de la cadena de formato en r2
    bl printf            @ Llama a printf para imprimir la cadena formateada

    add sp, sp, #16      @ Restaura el puntero de pila después de usarla
    bx lr

stop:	wfi
