	.data
str: 	.asciz "Operando: %d %c %d = %d.%d"

	.text
main:

    
    cmp r2,#'+'
    beq sum
    cmp r2,#'-'
    beq subtract
    cmp r2,#'*'
    beq multiply
    cmp r2,#'/'
    beq divide
  
    b stop

sum:
    	add r3, r0, r1     @ Suma los operandos
   	b print_result

subtract:
	sub r3, r0, r1     @ Resta el segundo operando al primero
	b print_result

multiply:
    mov r3,r0
    mul r3, r1     @ Multiplica los operandos
    b print_result

divide:
    mov r4,r0
    mov r5,r1
    mov r6,#10
    bl sdivide
    mov r7,r0
    mul r1, r6
    mov r0,r1
    mov r1,r5
    bl sdivide
    mov r6, r0
    mov r0,r4
    mov r1,r5
    mov r2,#'/'
    mov r3,r7
    mov r4,r6
    
     
    b print_result

print_result:
    sub sp, sp, #16       @ Reserva espacio para cuatro palabras (4*4 bytes = 16 bytes) en la pila
    str r4, [sp, #12]     @ Almacena el resultado decimal en la tercera words adelante del stack pointer
    str r3, [sp, #8]      @ Almacena el resultado en la segunda word adelante del stack pointer
    str r1, [sp, #4]      @ Almacena el segundo termino en la primer word del stack pointer
    str r2, [sp]          @ Almacena el operador en la word del stack pointer
    mov r3, r0		  @ Almacena el primer termino una word antes del stack pointer

    mov r0, #0           @ Columna para PrintF
    mov r1, #0           @ Fila para PrintF
    ldr r2, =str         @ Carga la dirección de la cadena de formato en r2
    bl printf            @ Llama a printf para imprimir la cadena formateada

    add sp, sp, #16      @ Restaura el puntero de pila después de usarla
    b stop

stop:	wfi
