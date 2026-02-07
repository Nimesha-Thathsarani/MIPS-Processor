@ ARM Assembly - Lab 1
@ E Number :
@ Name :

	.text 	@ instruction memory
	.global main
main:
	@ stack handling, will discuss later
	@ push (store) lr to the stack
	sub sp, sp, #4
	str lr, [sp, #0]

	@ load values
	ldr r0, =array_a
	ldr r1, =array_b
	mov r2, #3
	mov r3, #7
	mov r4, #10

	
	@ Write YOUR CODE HERE
	@ b[4] = 6 + a[9] - a[3] + b[1] – ( c + d - e )
	@ Base address of a in r0
	@ Base address of b in r1
	@ c,d,e in r2,r3,r4 respectively 

	@ ---------------------

 	ldr r5,[r0,#36]  @load a[9] to r5
 	ldr r6,[r0,#12]  @load b[3] to r6
 	sub r5,r5,r6     @substract a[3] from a[9]
 	add r6,r5,#6     @add r5 and 6
 	ldr r5,[r1,#4]   @load b[1] to r5
 	sub r5,r5,r2     @substract c from b[1]
 	add r6,r5,r6     @add 6 ,a[9]-a[3],b[1]-c
 	sub r5,r6,r3     @subtract d from r6
  	add r6,r5,r4	 @add e to r5
 	str r6,[r1,#16]  @store r6 in b[4] 
 
	@ ---------------------
	
	
	@ load aguments and print
	ldr r0, =format
	ldr r2, =array_b
	ldr r1, [r2,#16]
	bl printf

	@ stack handling (pop lr from the stack) and return
	ldr lr, [sp, #0]
	add sp, sp, #4
	mov pc, lr

	
	
	.data	@ data memory
	
format: .asciz "The Answer is %d (Expect -3 if correct)\n"
	
	@array called array_a of size 40 bytes
	.balign 4 			@align to an address of multiple of 4
array_a: .word 1,5,7,67,5,54,65,23,34,54

	@array called array_b of size 20 bytes
	.balign 4 			@align to an address of multiple of 4
array_b: .word 7,4,8,3,5
