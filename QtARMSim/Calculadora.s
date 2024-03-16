	.data
str: .asciz "Operando: %d %c %d = $d"

	.text
main:	bl sum


sum:	mov r0, #0
	mov r1, #0 
	ldr r2, =str
	bl printf
	

sub:	mov r0, #0
	mov r1, #0 
	ldr r2, =str
	bl printf

mult:	mov r0, #0
	mov r1, #0 
	ldr r2, =str
	bl printf

div:	mov r0, #0
	mov r1, #0 
	ldr r2, =str
	bl printf

stop: wfi
