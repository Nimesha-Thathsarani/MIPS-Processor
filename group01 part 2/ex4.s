@ ARM Assembly - exercise 4
@ Group Number : 01

	.text 	@ instruction memory
	.global main
main:
	@ stack handling, will discuss later
	@ push (store) lr to the stack
	sub sp, sp, #4
	str lr, [sp, #0]

	@ load values
	mov r0, #3

	
	@ Write YOUR CODE HERE
	@ if (i>5) f = 70;
	@ else if (i>3) f=55;
	@ else f = 30;
	@ i  in r0
	@ Put f to r5
	@ Hint : Use MOV instruction
	@ MOV r5,#70 makes r5=70

	@ ---------------------
	
	cmp r0,#5;@compare i and 5
	ble Elseif;@skip if(i>5)
	mov r5,#70;@f=70
	B Exit

Elseif:
	cmp r0,#3;@compare i and 3
	ble Else;@skip if i>3
	mov r5,#55;@f=5
	B Exit

Else:
	mov r5,#30;@f=30
	
Exit:
	
	
	
	
	
	
	
	@ ---------------------
	
	
	@ load aguments and print
	ldr r0, =format
	mov r1, r5
	bl printf

	@ stack handling (pop lr from the stack) and return
	ldr lr, [sp, #0]
	add sp, sp, #4
	mov pc, lr

	.data	@ data memory
format: .asciz "The Answer is %d (Expect 30 if correct)\n"

