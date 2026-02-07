    .text @instruction memory
    .global main
main:
    @stack handling
    sub sp, sp, #4	
    str lr, [sp]		@store lr in the stack


    ldr r0, =formatpP1		@printf for getting the number of strings
    bl printf

    sub sp, sp, #4		@allocate stack for input


    ldr r0, =formatsNoStr	@scanf for number of strings
    mov r1, sp
    bl scanf 			@scanf("%d", sp)


    ldr r0, [sp]		@store scanned int_num in r0
   
    add sp, sp, #4		@release stack

    cmp r0, #0			@compare number of strings with 0

    blt ifinvalidInput		@call function to get string and reverse it.
    blgt reverseString
    b ifZero

ifinvalidInput:
    ldr r0, = formatsInvalid
    bl printf
    
ifZero:
    ldr lr, [sp]	        @stack handling and returning
    add sp, sp, #4
    mov pc, lr


reverseString:
    
    sub sp, sp, #8		@backup and allocate memory in stack for registers
    str r0, [sp, #4]
    str lr, [sp,#0]

    cmp r0, #0			@if the count is 0, return. 
    bgt gettingInput		@else go to getInput

    ldr lr, [sp]		@restore link register and release stack
    add sp, sp, #8
    mov pc, lr
    


gettingInput:
   
    mov r1, r0			@print prompt"Enter input string"
    ldr r0, =formatpP2
    bl printf

    @scan input

    sub sp, sp, #200		@allocate space for the string in the stack


    ldr r0, =formatsString	@call scanf
    mov r1, sp
    bl scanf

    ldr r0, =formatpOutput	@print - Output string %d is....
    ldr r1, [sp, #204]
    bl printf

   
    mov r0, sp			@reverse and print string by calling reverseAString function
    bl reverseAString
 
    add sp, sp, #200		@release stack

    
    ldr r0, [sp, #4]		@restore registers
    ldr lr, [sp]
    add sp, sp, #8
    
    sub r0, r0, #1		@decrement count
    b reverseString		@continue looping
   
reverseAString:
    
    sub sp, sp, #4		@back up link register
    str lr, [sp]

    
    mov r4, r0			@save original memory address of where the string begins at
   
Loop:

    ldrb r1, [r0, #0]	    	@load character to r1
      
    cmp r1, #0			@check for the null character
    				
    beq printCharLoop		@if null go to printCharacter

   
    add r0, r0, #1		@increment r0

    b Loop			@continue loop

printCharLoop:
    
    cmp r0, r4			@check if r0 < original address of r0
    blt exitReverse
   
    
    sub sp, sp, #4		@storing  r0
    str r0, [sp]
   
   
    ldrb r1, [r0, #0]
    ldr r0, =formatpChar	@printing character
    bl printf
   
    ldr r0, [sp]		@restoring r0 and releasing stack
    add sp, sp, #4

    
    sub r0, r0, #1		@decrement r0 addr
    b printCharLoop

exitReverse:
    
    ldr r0, =formatpNewLine	@print new line
    bl printf    

    
    ldr lr, [sp]		@restore registers
    add sp, sp, #4
    mov pc, lr
   
   
   
   
       .data @data memory
formatpP1: .asciz "Enter the number of strings: \n"
formatsNoStr: .asciz "%d"
formatsInvalid: .asciz "Invalid Number\n"
formatpP2: .asciz "Enter input string %d\n"
formatsString: .asciz "%*c%[^\n]"
formatpChar: .asciz "%c"
formatpNewLine: .asciz "\n"
formatpTest: .asciz "%d, %d\n"
formatpOutput: .asciz "Output string %d is...\n"

