 	.data

	@ --------------
	@ Inicialización
	@ --------------
num1:	.word 0
num2: 	.word 0
ope:	.word 0
res:	.word 0
point:  .word 32
dec1:	.word 32
dec2:	.word 32
dec3:	.word 32
dec4:	.word 32
str_f: 	.asciz "%d %c %d = %d%c%c%c%c"


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
    	bl sdivide @ Implementar sdivide con r0,r1, dejando r0 como resultado y r1 como residuo
	ldr r3,=res
	str r0,[r3]

	@ Calcular Decimales

	mov r4,#1 @ Inicializar Iterador
	mov r5,#5 @ Rango final del Iterador
loop_dec:
	
	@ Preparación del Residuo
	mov r6,#10 @ Inicilizar base numerica
	mul r1, r6 @ Multiplica el Residuo por la base numerica
    	mov r0,r1 @ Guarda el residuo*base n en r0 para sdivide, como nuevo dividendo
	
	@ Carga de Divisor
	ldr r3,=num2	@ Referencia en Memoria para el divisor
	ldr r1,[r3] @ Carga el mismo divisor previamente guardado
	
	@ División
    	bl sdivide @ Implementa sdivide con r0,r1, dando r0 como resultado y r1 como residuo
	
	@ Configuración Dirección en Memoria dinamica
	ldr r3,=point @ Referencia en memoria para Decimales
	mov r6,#4 @ Bytes de Desplazamiento
	mov r7,r4 @ Copias Iterador
	mul r7,r6 @ Numero de Iteración * 4 bits, para acceder al decimal correspondiente de la Iteración

	@ Carga de Resultado
	add r0, r0, #48 @ En ascii los caracteres de numeros empiezan en 48
	str r0,[r3,r7] @ Guarda el Decimal en Memoria  

	add r4,r4,#1 @Incrementa en Uno
	cmp r4,r5 @ Comparar Inicio y Final
	bne loop_dec
	
	@ Colocar el Punto de Decimal
	ldr r3,=point
	mov r4,#46
	str r4, [r3]
	
	@ Redondear
		
	@ Carga Decimal
	ldr r2,=dec3
	ldr r0,[r2]

	@Carga Decimal Extra
	ldr r3,=dec4
	ldr r1,[r3]
	
	cmp r1,#53
	blt continue
	
	@ Cambia el Decimal
	add r0,r0,#1
	str r0,[r2]

continue:
	@Quitar Decimales en Cero a la derecha
	ldr r1,=dec3
	ldr r0,[r1]
	cmp r0,#48
	beq two_dec
	@ Imprimir
    	b print_result
	
two_dec: mov r0,#32
	 str r0,[r1]
	 ldr r1,=dec2
	 ldr r0,[r1]
	 cmp r0,#48
	 beq one_dec
	 @ Imprimir
    	 b print_result

one_dec: mov r0,#32
	 str r0,[r1]
	 ldr r1,=dec1
	 ldr r0,[r1]
	 cmp r0,#48
	 beq zero_dec
	 @ Imprimir
    	 b print_result

zero_dec:mov r0,#32
	 str r0,[r1]
	 ldr r1,=point
	 str r0,[r1]
	 @ Imprimir
    	 b print_result
	
    	


print_result:
	@ Carga de Memoria
	bl read
    	sub sp, sp, #28       @ Reserva espacio para siete palabras (7*4 bytes = 28 bytes) en la pila
	str r7, [sp, #24]     @ Almacena el tercer resultado decimal en la quinta words adelante del stack pointer, mediante str
	str r6, [sp, #20]     @ Almacena el segundo resultado decimal en la quinta words adelante del stack pointer, mediante str
   	str r5, [sp, #16]     @ Almacena el primer resultado decimal en la cuarta words adelante del stack pointer, mediante str
	str r4, [sp, #12]     @ Almacena el puntero en la tercera words adelante del stack pointer, mediante str
    	str r3, [sp, #8]      @ Almacena el resultado en la segunda word adelante del stack pointer, mediante str
    	str r1, [sp, #4]      @ Almacena el segundo termino en la primer word del stack pointer, mediante str
    	str r2, [sp]          @ Almacena el operador en la word del stack pointer, mediante str
    	mov r3, r0	      @ Almacena el primer termino una word antes del stack pointer, mediante str
    	mov r0, #0           @ Columna para PrintF
    	mov r1, #0           @ Fila para PrintF
    	ldr r2, =str_f         @ Carga la dirección de la cadena de formato en r2
    	bl printf            @ Llama a printf para imprimir la cadena formateada

    	add sp, sp, #16      @ Restaura el puntero de pila después de usarla
	bl read
    	b stop

read:
	ldr r7,=num1
	ldr r0,[r7]
	ldr r7,=num2
	ldr r1,[r7]
	ldr r7,=ope
	ldr r2,[r7]
	ldr r7,=res
	ldr r3, [r7]
	ldr r7,=point
	ldr r4, [r7]
	ldr r7,=dec1
	ldr r5,[r7]
	ldr r7,=dec2
	ldr r6,[r7]
	ldr r7,=dec3
	ldr r7,[r7]
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
