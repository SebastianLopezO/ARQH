	.data
str: 	.asciz "Operando: %d %c %d = %d"

	.text
main:
	
	sub sp,sp, #8
	str #10, [sp,#4]
	str #2, [sp]
    	mov r5, r2        @ Copia la dirección de la cadena de formato
	mov r0,#0
	mov r1,#0
	ldr r2,=str
    	bl printf         @ Llama a la función printf de QTARMSIM
  	add sp,sp, #8

stop:	wfi
