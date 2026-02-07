@ ARM Assembly - exercise 6 
@ Group Number : 01

	.text 	@ instruction memory
	
	
@ Write YOUR CODE HERE	

@ ---------------------	
fact:
	mov r1,#1;	@i=1
	mov r2,#1;	@mult=1
	mov r3,r0;	@move n to r3
	cmp r3,#1;	@compare n and 1
	ble END;	@if n<=1 then do END

LOOP:
	mov r12,r2;
	mul r2,r12,r1;	@mult=mult*i
	add r1,r1,#1;	@i=i+1	
	cmp r1,r3;	@compare i and n
	ble LOOP
	
END:    
	mov r0,r2;	@move the mult to r0
	mov pc,lr


@ ---------------------	

.global main
main:
	@ stack handling, will discuss later
	@ push (store) lr to the stack
	sub sp, sp, #4
	str lr, [sp, #0]

	mov r4, #4 	@the value n

	@ calling the fact function
	mov r0, r4 	@the arg1 load
	bl fact
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
format: .asciz "Factorial of %d is %d\n"

