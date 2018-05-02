.global main
.func main
   
main:
    BL _seedrand            @ seed random number generator with current time
    MOV R0, #0              @ initialze index variable
writeloop:
    CMP R0, #10             @ check to see if we are done iterating
    BEQ writedone           @ exit loop if done
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    PUSH {R0}               @ backup iterator before procedure call
    PUSH {R2}               @ backup element address before procedure call
    BL _scanf               @ branch to scanf procedure with return
    POP {R2}                @ restore element address
    STR R0, [R2]            @ write the address of a[i] to a[i]
    POP {R0}                @ restore iterator
    ADD R0, R0, #1          @ increment index
    B   writeloop           @ branch to next loop iteration
writedone:
    MOV R0, #0              @ initialze index variable
readloop1:
    CMP R0, #10             @ check to see if we are done iterating
    BEQ readdone1           @ exit loop if done
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address 
    PUSH {R0}               @ backup register before printf
    PUSH {R1}               @ backup register before printf
    PUSH {R2}               @ backup register before printf
    MOV R2, R1              @ move array value to R2 for printf
    MOV R1, R0              @ move array index to R1 for printf
    BL  _printf             @ branch to print procedure with return
    POP {R2}                @ restore register
    POP {R1}                @ restore register
    POP {R0}                @ restore register
    ADD R0, R0, #1          @ increment index
    B   readloop1           @ branch to next loop iteration
readdone1:
    BL _prompt1		    @ branch to prompt procedure with return
    BL _scanf               @ branch to scanf procedure with return
    MOV R5, R0		    @ move return value R0 to argument register R5 for search value
    MOV R6, #0		    @ initialize counter value
    MOV R0, #0              @ initialze index variable
readloop2:
    CMP R0, #10             @ check to see if we are done iterating
    BEQ readdone2           @ exit loop if done
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address 
    PUSH {R0}               @ backup register before printf
    PUSH {R1}               @ backup register before printf
    PUSH {R2}               @ backup register before printf
    MOV R2, R1              @ move array value to R2 for printf
    MOV R1, R0              @ move array index to R1 for printf
    CMP R5, R2
    ADDEQ R6, R6, #1	    @ increment counter if(R5 == R2)
    BLEQ _printf	    @ branch to print procedure with return if(R5 == R2)
    POP {R2}                @ restore register
    POP {R1}                @ restore register
    POP {R0}                @ restore register
    ADD R0, R0, #1          @ increment index
    B   readloop2           @ branch to next loop iteration
readdone2:
    CMP R6, #0
    BLEQ _printf2	    @ branch to print2 procedure with return if(R6 == 0)
    B _exit                 @ exit if done
    
_exit:  
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #21             @ print string length
    LDR R1, =exit_str       @ string at label exit_str:
    SWI 0                   @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall

_prompt1:
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #22             @ print string length
    LDR R1, =prompt_str     @ string at label prompt_str1:
    SWI 0                   @ execute syscall
    MOV PC, LR              @ return
       
_printf:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return
       
_printf2:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str2    @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return
    
_scanf:
    PUSH {LR}               @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {PC}                @ return
    
_seedrand:
    PUSH {LR}               @ backup return address
    MOV R0, #0              @ pass 0 as argument to time call
    BL time                 @ get system time
    MOV R1, R0              @ pass sytem time as argument to srand
    BL srand                @ seed the random number generator
    POP {PC}                @ return 
    
_getrand:
    PUSH {LR}               @ backup return address
    BL rand                 @ get a random number
    POP {PC}                @ return 
   
.data

.balign 4
a:              .skip       400
format_str:     .asciz      "%d"
prompt_str:     .asciz      "ENTER A SEARCH VALUE: "
printf_str:     .asciz      "array_a[%d] = %d\n"
printf_str2:    .asciz      "That value does not exist in the array!\n"
debug_str:
.asciz "R%-2d   0x%08X  %011d \n"
exit_str:       .ascii      "Terminating program.\n"
