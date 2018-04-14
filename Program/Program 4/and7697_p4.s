.global main
.func main
   
main:
    BL  _prompt1	    @ branch to prompt1 procedure with return
    BL  _scanf		    @ branch to scanf procedure with return
    PUSH {R0}		    @ backup R0 for n for numerator to stack
    BL  _prompt2	    @ branch to prompt2 procedure with return
    BL  _scanf		    @ branch to scanf procedure with return
    MOV R1, R0		    @ move return value R0 to argument register R1 for d for denominator
    POP {R0}		    @ restore R0 for n for numerator from stack
    PUSH {R1}		    @ backup R1 for d for demoninator to stack
    PUSH {R0}		    @ backup R0 for n for numerator to stack
    MOV R2, R1		    @ move R1 to R2 for _printf procedure call
    MOV R1, R0		    @ move R0 to R1 for _printf procedure call
    BL  _printf		    @ print the inputs
    MOV R0, R1		    @ move R1 back to R0
    MOV R1, R2		    @ move R2 back to R1
    POP {R0}		    @ restore R0 for n for numerator from stack
    POP {R1}		    @ restore R1 for d for denominator from stack
    VMOV S0, R0             @ move the numerator to floating point register
    VMOV S1, R1             @ move the denominator to floating point register
    VCVT.F32.U32 S0, S0     @ convert unsigned bit representation to single float
    VCVT.F32.U32 S1, S1     @ convert unsigned bit representation to single float
	
    VDIV.F32 S2, S0, S1     @ compute S2 = S0 / S1
    
    VCVT.F64.F32 D4, S2     @ covert the result to double precision for printing
    VMOV R1, R2, D4         @ split the double VFP register into two ARM registers
    BL  _printf_result      @ print the result
    
    B main		    @ loop back main
   
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
    MOV R2, #38             @ print string length
    LDR R1, =prompt_str1    @ string at label prompt_str1:
    SWI 0                   @ execute syscall
    MOV PC, LR              @ return

_prompt2:
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #41             @ print string length
    LDR R1, =prompt_str2    @ string at label prompt_str2:
    SWI 0                   @ execute syscall
    MOV PC, LR              @ return

_printf:
    PUSH {LR}		    @ store LR since printf call overwrites
    LDR R0, =printf_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}		    @ return

_printf_result:
    PUSH {LR}               @ push LR to stack
    LDR R0, =result_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ pop LR from stack and return
    
_scanf:
    PUSH {LR}               @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {PC}                @ return

.data
format_str:     .asciz      "%d"
prompt_str1:    .asciz      "Input an integer for the numerator n: "
prompt_str2:    .asciz      "Input an integer for the denominator d: "
result_str:     .asciz      " %f \n"
printf_str:     .asciz      "%d / %d = "
exit_str:       .ascii      "Terminating program.\n"
