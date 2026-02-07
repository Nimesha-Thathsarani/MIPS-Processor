@ ARM Assembly - lab 3.1
@ Group NO -01
@ Roshan Ragel - roshanr@pdn.ac.lk
@ Hasindu Gamaarachchi - hasindu@ce.pdn.ac.lk

	.text 	@ instruction memory

	
@ Write YOUR CODE HERE	

@ ---------------------	
mypow:
	sub sp,sp,#16	@adjust stack for 4 elements
	str lr,[sp,#12]
	str r4,[sp,#8]
	str r5,[sp,#4]
	str r6,[sp,#0]
	
	mov r6,#1	@i=1
	mov r4,r0	@ move x to r4
	mov r5,r1	@ move n to r5
	mov r1,#1	@move 1 to r1 ( to use as mult)
	
LOOP:	cmp r6,r5	@ i< n
	bge END 	@i>= n
	
	
	mul r1,r0,r4	@mult=mult*x
	mov r0,r1	@move mult to r0
	add r6,r6,#1	@i++
	bl LOOP
	
END:
	ldr lr,[sp,#12]	@release the memory
	ldr r4,[sp,#8]
	ldr r5,[sp,#4]
	ldr r6,[sp,#0]
	add sp,sp,#16
	mov pc,lr
	
	








@ ---------------------	

	.global main
main:
	@ stack handling, will discuss later
	@ push (store) lr to the stack
	sub sp, sp, #4
	str lr, [sp, #0]

	mov r4, #8 	@the value x
	mov r5, #3 	@the value n
	

	@ calling the mypow function
	mov r0, r4 	@the arg1 load
	mov r1, r5 	@the arg2 load
	bl mypow
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
format: .asciz "%d^%d is %d\n"

