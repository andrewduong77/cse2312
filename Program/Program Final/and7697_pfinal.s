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
    BL _getrand             @ get a random number
    MOV R1, R0              @ move generated random number to R1 for mod evaluation
    MOV R2, #1000           @ move a constant value to R2 for mod evaluation
    BL _mod_unsigned        @ compute the remainder of R1 / R2
    POP {R2}                @ restore element address
    STR R0, [R2]            @ write the address of a[i] to a[i]
    POP {R0}                @ restore iterator
    ADD R0, R0, #1          @ increment index
    B   writeloop           @ branch to next loop iteration
writedone:
    MOV R0, #0              @ initialze index variable
readloop:
    CMP R0, #10             @ check to see if we are done iterating
    BEQ readdone            @ exit loop if done
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address 
    PUSH {R0}               @ backup register before printf
    PUSH {R1}               @ backup register before printf
    PUSH {R2}               @ backup register before printf
    MOV R2, R1              @ move array value to R2 for printf
    BL  _max                @ get maximum value
    BL  _min                @ get minimum value
    MOV R1, R0              @ move array index to R1 for printf
    BL  _printf             @ branch to print procedure with return
    POP {R2}                @ restore register
    POP {R1}                @ restore register
    POP {R0}                @ restore register
    ADD R0, R0, #1          @ increment index
    B   readloop            @ branch to next loop iteration
readdone:
    PUSH {R0}               @ backup register before printf
    PUSH {R6}               @ backup register before printf
    MOV R1, R6              @ move minimum value to R1 for printf
    BL _printf_min          @ branch to print procedure with return
    POP {R6}                @ restore register
    POP {R0}                @ restore register
    PUSH {R0}               @ backup register before printf
    PUSH {R5}               @ backup register before printf
    MOV R1, R5              @ move maximum value to R1 for printf
    BL _printf_max          @ branch to print procedure with return
    POP {R5}                @ restore register
    POP {R0}                @ restore register
    B _exit                 @ exit if done
   
_max:
    PUSH {LR}               @ store the return address
    CMP R2, R5
    MOVHI R5, R2            @ if (R2 > R5) move R2 to R5
    POP {PC}                @ restore the stack pointer and return
   
_min:
    PUSH {LR}               @ store the return address
    CMP R2, R6
    MOVLO R6, R2            @ if (R2 < R6) move R2 to R6
    POP {PC}                @ restore the stack pointer and return
    
_exit:  
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #21             @ print string length
    LDR R1, =exit_str       @ string at label exit_str:
    SWI 0                   @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall
       
_mod_unsigned:
    cmp R2, R1              @ check to see if R1 >= R2
    MOVHS R0, R1            @ swap R1 and R2 if R2 > R1
    MOVHS R1, R2            @ swap R1 and R2 if R2 > R1
    MOVHS R2, R0            @ swap R1 and R2 if R2 > R1
    MOV R0, #0              @ initialize return value
    B _modloopcheck         @ check to see if
    _modloop:
        ADD R0, R0, #1      @ increment R0
        SUB R1, R1, R2      @ subtract R2 from R1
    _modloopcheck:
        CMP R1, R2          @ check for loop termination
        BHS _modloop        @ continue loop if R1 >= R2
    MOV R0, R1              @ move remainder to R0
    MOV PC, LR              @ return
       
_printf:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return
       
_printf_max:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_max     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return
       
_printf_min:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_min     @ R0 contains formatted string address
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
printf_str:     .asciz      "a[%d] = %d\n"
printf_max:     .asciz      "MAXIMUM VALUE = %d\n"
printf_min:     .asciz      "MINIMUM VALUE = %d\n"
debug_str:
.asciz "R%-2d   0x%08X  %011d \n"
exit_str:       .ascii      "Terminating program.\n"
