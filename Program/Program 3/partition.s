.global main
.func main
   
main:
    BL  _prompt1	@ branch to prompt1 procedure with return
    BL  _scanf		@ branch to scanf procedure with return
    MOV R1, R0		@ move return value R0 to argument register R1 for n
    PUSH {R1}		@ backup R1 for n to stack
    BL  _prompt2	@ branch to prompt2 procedure with return
    BL  _scanf		@ branch to scanf procedure with return
    MOV R2, R0		@ move return value R0 to argument register R2 for m
    POP {R1}		@ restore R1 for n from stack
    PUSH {R2}		@ backup R2 for m to stack
    PUSH {R1}		@ backup R1 for n to stack
    BL _count_partitions	@ call the _count_partitions procedure
    POP {R1}		@ restore R1 for n from stack
    POP {R2}		@ restore R2 for m from stack
    MOV R3, R2		@ move R2 to R3 for _printf
    MOV R2, R1		@ move R1 to R2 for _printf
    MOV R1, R0		@ move R0 to R1 for _printf
    BL  _printf		@ branch to print procedure with return
    B main		@ loop back main

_count_partitions:
    PUSH {LR}		@ store the return address

    CMP R1, #0
    MOVEQ R0, #1	@ if(n == 0)
    POPEQ {PC}		@     return 1;

    CMP R1, #0
    MOVLT R0, #0	@ if(n < 0)
    POPLT {PC}		@     return 0;

    CMP R2, #0
    MOVEQ R0, #0	@ if(m == 0)
    POPEQ {PC}		@     return 0;

    PUSH {R1}		@ backup R1 for n to stack
    PUSH {R2}		@ backup R2 for m to stack

    SUB R2, R2, #1	@ set R2 to m - 1

    @ R1 is n
    @ R2 is m - 1

    BL _count_partitions	@ calling count_partitions(n, m - 1), returning value to R0

    POP {R2}		@ restore R2 for m from stack
    POP {R1}		@ restore R1 for n from stack

    MOV R3, R0		@ store value returned by count_partitions(n, m - 1) in R3

    SUB R1, R1, R2	@ set R1 to n - m

    @ R1 is n - m
    @ R2 is m

    PUSH {R3}		@ backup R3 to stack
    BL _count_partitions	@ calling count_partitions(n - m, m), returning value to R0
    POP {R3}		@ restore R3 from stack
    ADD R0, R0, R3	@ add R3 to R0 (count_partitions(n, m - 1) + count_partitions(n - m, m)) and store it in R0 to return

    POP {PC}		@ restore the stack pointer and return

_prompt1:
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #31             @ print string length
    LDR R1, =prompt_str1    @ string at label prompt_str1:
    SWI 0                   @ execute syscall
    MOV PC, LR              @ return

_prompt2:
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #43             @ print string length
    LDR R1, =prompt_str2    @ string at label prompt_str2:
    SWI 0                   @ execute syscall
    MOV PC, LR              @ return
       
_printf:
    MOV R4, LR              @ store LR since printf call overwrites
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
    POP {PC}                 @ return

.data
format_str:     .asciz      "%d"
prompt_str1:    .asciz      "Type a positive integer for n: "
prompt_str2:    .asciz      "Type a positive integer for parts up to m: "
printf_str:     .asciz      "there are %d partitions of %d using integers up to %d\n"
exit_str:       .ascii      "Terminating program.\n"