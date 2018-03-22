.global main
.func main
   
main:
    BL  _prompt             @ branch to prompt procedure with return
    BL  _scanf              @ branch to scanf procedure with return
    MOV R1, R0              @ move return value R0 to argument register R1
    PUSH {R1}
    BL  _prompt2
    BL  _scanf2
    MOV R2, R0
    PUSH {R2}
    BL  _prompt3
    BL  _scanf3
    MOV R5, R0
    POP {R2}
    POP {R1}
    CMP R2, #43
    BEQ add
    CMP R2, #45
    BEQ sub
    CMP R2, #42
    BEQ mul
    CMP R2, #77
    BEQ max

finish:
    BL  _printf             @ branch to print procedure with return
    @B   main                @ branch to main with no return
    B   _exit               @ branch to exit procedure with no return
   
add:
    ADD R0, R1, R5          @ R1 + R5 = R0
    B finish

sub:
    SUB R0, R1, R5	    @ R1 - R5 = R0
    B finish

mul:
    MUL R0, R1, R5          @ R1 * R5 = R0
    B finish

max:
    CMP R1, R5
    MOVHI R0, R1	    @ if(R1 > R0) R5
    CMP R1, R5
    SUBLT R0, R5, #0        @ if(R5 > R1) R5 = R0
    B finish

_exit:  
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #21             @ print string length
    LDR R1, =exit_str       @ string at label exit_str:
    SWI 0                   @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall

_prompt:
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #39             @ print string length
    LDR R1, =prompt_str     @ string at label prompt_str:
    SWI 0                   @ execute syscall
    MOV PC, LR              @ return

_prompt2:
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #34             @ print string length
    LDR R1, =prompt_str2     @ string at label prompt_str:
    SWI 0                   @ execute syscall
    MOV PC, LR              @ return

_prompt3:
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #40             @ print string length
    LDR R1, =prompt_str3    @ string at label prompt_str:
    SWI 0                   @ execute syscall
    MOV PC, LR              @ return
       
_printf:
    MOV R4, LR              @ store LR since printf call overwrites
    MOV R1, R0
    LDR R0, =printf_str     @ R0 contains formatted string address
    MOV R1, R1              @ R1 contains printf argument (redundant line)
    BL printf               @ call printf
    MOV PC, R4              @ return
    
_scanf:
    PUSH {LR}                @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {PC}

_scanf2:
    PUSH {LR}
    SUB SP, SP, #4
    MOV R3, #0
    STR R3, [SP]
    LDR R0, =format_str2
    MOV R1, SP
    BL scanf
    LDR R0, [SP]
    ADD SP, SP, #4
    POP {PC}
    
_scanf3:
    PUSH {LR}                @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R5 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {PC}

.data
format_str:     .asciz      "%d"
format_str2:    .asciz      "\n%c"
prompt_str:     .asciz      "Type the first number and press enter: "
prompt_str2:    .asciz      "Type an operator and press enter: "
prompt_str3:    .asciz      "Type the second number and press enter: "
printf_str:     .asciz      "The result is: %d\n"
exit_str:       .ascii      "Terminating program.\n"
