@ ARM Assembly - exercise 5
@ Group Number :01

	.text 	@ instruction memory
	.global main
main:
	@ stack handling, will discuss later
	@ push (store) lr to the stack
	sub sp, sp, #4
	str lr, [sp, #0]
	
	@ Write YOUR CODE HERE
	
	@ j=0;
	@ for (i=0;i<10;i++)
	@ 		j+=i;	
	
	@ Put final j to r5

	@ ---------------------
	mov r5,#0;@j=0
	mov r1,#0;@i=0
loop:	
	cmp r1,#10;@compare i and 10
	bge exit ; @if i>=10 loop ends
	add r5,r5,r1;@j+=i
	add r1,r1,#1;@i++
	b loop
exit:
	
	
	
	
	
	
	
	
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
format: .asciz "The Answer is %d (Expect 45 if correct)\n"

