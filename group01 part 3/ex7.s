@ ARM Assembly - exercise 7 
@ Group Number : 01

	.text 	@ instruction memory

	
@ Write YOUR CODE HERE	

@ ---------------------	
Fibonacci:
	sub sp,sp,#12 @space for 3 regidters
	@saving r4 and r5 on stack
	str r4, [sp, #8]
	str r5, [sp, #4]
	str lr, [sp, #0] @save return addrress
	mov r4,r0 @getting the n value
	cmp r4,#2
	bgt next
	mov r0,#1
	@releasing
	ldr lr, [sp,#0]
	ldr r5, [sp,#4]
	ldr r4, [sp,#8]
	add sp, sp, #12
	mov pc, lr
	
next:
	sub r0,r4,#1 @n-1
	bl Fibonacci
	mov r5,r0 @move value to r5
	sub r0,r4,#2 @n-2
	bl Fibonacci
	add r0,r5,r0 @getting the final fibonacci
	
	@releasing
	ldr lr, [sp,#0]
	ldr r5, [sp,#4]
	ldr r4, [sp,#8]
	add sp, sp, #12
	mov pc, lr









@ ---------------------
	
	.global main
main:
	@ stack handling, will discuss later
	@ push (store) lr to the stack
	sub sp, sp, #4
	str lr, [sp, #0]

	mov r4, #8 	@the value n

	@ calling the Fibonacci function
	mov r0, r4 	@the arg1 load
	bl Fibonacci
	mov r5,r0
	

	@ load aguments and print
	ldr r0, =format
	mov r1, r4
	mov r2, r5
	bl printf

	@ stack handling (pop lr from the stack) and return
	ldr lr, [sp, #0]
	add sp, sp, #4
	mov pc, lr

	.data	@ data memory
format: .asciz "F_%d is %d\n"

