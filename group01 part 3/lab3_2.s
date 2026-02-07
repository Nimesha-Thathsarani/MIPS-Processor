@ ARM Assembly - lab 3.2 
@ Group Number :

	.text 	@ instruction memory

	
@ Write YOUR CODE HERE	

@ ---------------------	
gcd:
	sub sp, sp, #16
	str r4, [sp, #12]
	str r5, [sp, #8]
	str r6, [sp, #4]
	str lr ,[sp, #0]
	
	mov r4 ,r0 @ value of a
	mov r5 ,r1 @ value of b
	
	cmp r5,#0 @is b ==0
	bne else
	mov r0,r4 @if b==0 : return a
	ldr r4, [sp, #12]
	ldr r5, [sp, #8]
	ldr r6, [sp, #4]
	ldr lr, [sp, #0]
	add sp, sp, #16
	mov pc,lr
	
	else:
		mov r0, r5 @moving the value of b to register (a==b)
		cmp r5,r4 @compare remindr r4 and b
		bgt exit  @if remainder is lager than b then exit
		sub r4, r4, r5 @remainder = remainder - b
		
		
	exit:
		mov r1,r4 @moving a mod b to register belongs b (b=a%b)
		bl gcd
		ldr r4, [sp, #12]
		ldr r5, [sp, #8]
		ldr r6, [sp, #4]
		ldr lr, [sp, #0]
		add sp, sp, #16
		mov pc,lr
	
		
		
		










@ ---------------------	

	.global main
main:
	@ stack handling, will discuss later
	@ push (store) lr to the stack
	sub sp, sp, #4
	str lr, [sp, #0]

	mov r4, #64 	@the value a
	mov r5, #24 	@the value b
	

	@ calling the mypow function
	mov r0, r4 	@the arg1 load
	mov r1, r5 	@the arg2 load
	bl gcd
	mov r6,r0
	

	@ load aguments and print
	ldr r0, =format
	mov r1, r4
	mov r2, r5
	mov r3, r6
	bl printf

	@ stack handling (pop lr from the stack) and return
	ldr lr, [sp, #0]
	add sp, sp, #4
	mov pc, lr

	.data	@ data memory
format: .asciz "gcd(%d,%d) = %d\n"

