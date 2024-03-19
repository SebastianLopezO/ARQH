	.data

	@ --------------
	@ Inicialización
	@ --------------
num1:	.word 0
num2: 	.word 0
ope:	.word 0
res:	.word 0
dec1:	.word 0
dec2:	.word 0
str_f: 	.asciz "%d %c %d = %d.%d%d"


	.text

	@ --------------
	@ Programa Invocador
	@ --------------

main:
    	bl write
    	cmp r2,#'+'
    	beq sum
    	cmp r2,#'-'
    	beq subtract
    	cmp r2,#'*'
    	beq multiply
    	cmp r2,#'/'
    	beq divide
    	b stop

stop:	wfi

	@ --------------
	@ Subrutinas
	@ --------------

sum:
    	add r3, r0, r1     @ Suma los operandos
	ldr r4,=res
	str r3,[r4]
   	b print_result

subtract:
	sub r3, r0, r1     @ Resta el segundo operando al primero
	ldr r4,=res
	str r3,[r4]
	b print_result

multiply:
    	mov r3,r0
    	mul r3, r1     @ Multiplica los operandos
	ldr r4,=res
	str r3,[r4]
    	b print_result

divide:
    	mov r6,#10 @ Inicilizar base numerica
    	bl sdivide @ Implementar sdivide con r0,r1, dejando r0 como resultado y r1 como residuo
	ldr r3,=res
	str r0,[r3]
    	mul r1, r6 @ Multiplica el Residuo por la base numerica
	@ Calcular Primer Decimal
    	mov r0,r1 @ Guarda el residuo*base n en r0 para sdivide, como nuevo dividendo
	ldr r3,=num2
	ldr r1,[r3] @ Carga el mismo divisor previamente guardado
    	bl sdivide @ Implementa sdivide con r0,r1, dando r0 como resultado y r1 como residuo
	ldr r3,=dec1
	str r0,[r3] @ Guarda el Primer Decimal en Memoria


    	@ Imprimir
    	b print_result



print_result:
	@ Carga de Memoria
	bl read
    	sub sp, sp, #20       @ Reserva espacio para cinco palabras (5*4 bytes = 20 bytes) en la pila
	str r5, [sp, #16]     @ Almacena el resultado decimal en la tercera words adelante del stack pointer, mediante str
   	str r4, [sp, #12]     @ Almacena el resultado decimal en la tercera words adelante del stack pointer, mediante str
    	str r3, [sp, #8]      @ Almacena el resultado en la segunda word adelante del stack pointer, mediante str
    	str r1, [sp, #4]      @ Almacena el segundo termino en la primer word del stack pointer, mediante str
    	str r2, [sp]          @ Almacena el operador en la word del stack pointer, mediante str
    	mov r3, r0		  @ Almacena el primer termino una word antes del stack pointer, mediante str

    	mov r0, #0           @ Columna para PrintF
    	mov r1, #0           @ Fila para PrintF
    	ldr r2, =str_f         @ Carga la dirección de la cadena de formato en r2
    	bl printf            @ Llama a printf para imprimir la cadena formateada

    	add sp, sp, #16      @ Restaura el puntero de pila después de usarla
	bl read
    	b stop

read:
	ldr r6,=num1
	ldr r0,[r6]
	ldr r6,=num2
	ldr r1,[r6]
	ldr r6,=ope
	ldr r2,[r6]
	ldr r6,=res
	ldr r3, [r6]
	ldr r6,=dec1
	ldr r4,[r6]
	ldr r6,=dec2
	ldr r5,[r6]
	bx lr

write:
	ldr r4, =num1
	ldr r5, =num2
        ldr r6, =ope
	str r0, [r4]
	str r1, [r5]
	str r2, [r6]
	bx lr
	.end
