@ ARM Assembly - lab 2
@ Group Number :01

	.text 	@ instruction memory
	.global main
main:
	@ stack handling, will discuss later
	@ push (store) lr to the stack
	sub sp, sp, #4
	str lr, [sp, #0]

	@ load values
	
	@ Write YOUR CODE HERE
	
	@	Sum = 0;
	@	for (i=0;i<10;i++){
	@			for(j=5;j<15;j++){
	@				if(i+j<10) sum+=i*2
	@				else sum+=(i&j);	
	@			}	
	@	} 
	@ Put final sum to r5


	@ ---------------------
	
	mov r5,#0;@sum=0
	mov r1,#0;@i=0
	
loop1: 
	cmp r1,#10;@compare i and 10 
	bge exit;@skip if(i<10)

	mov r2,#5;@j=5
	b loop2;
then_after:
	add r1,r1,#1;@i++
	b loop1;

loop2: 
	cmp r2,#15;@compare j and 15
	bge then_after;@skip if(j<15)
	add r3, r1,r2;@i+j
	cmp r3,#10;@compare i+j and 10
	bge else;@skip if(i+j<10)
	add r5,r5,r1,lsl #1;
	b then;
then:
	add r2,r2,#1;@j++
	b loop2;
		
else:
	and r4, r1,r2; @ i and j
	add r5,r5,r4;@ sum+=(i and j)
	b then;
	

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
format: .asciz "The Answer is %d (Expect 300 if correct)\n"

