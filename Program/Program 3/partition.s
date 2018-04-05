.global main
.func main
   
main:
    BL  _prompt1            @ branch to prompt1 procedure with return
    BL  _scanf              @ branch to scanf procedure with return
    MOV R1, R0              @ move return value R0 to argument register R1 for n
    PUSH {R1}
    BL  _prompt2            @ branch to prompt2 procedure with return
    BL  _scanf              @ branch to scanf procedure with return
    MOV R2, R0              @ move return value R0 to argument register R2 for m
    POP {R1}
    PUSH {R2}
    PUSH {R1}
    BL _count_partitions
    POP {R1}
    POP {R2}
    MOV R3, R2
    MOV R2, R1
    MOV R1, R0
    BL  _printf             @ branch to print procedure with return
    B   _exit               @ branch to exit procedure with no return

_count_partitions:
   PUSH {LR}		@ store the return address

   CMP R1, #0		@ compare the input argument to 0
   MOVEQ R0, #1		@ set return value to 1 if equal
   POPEQ {PC}		@ restore stack pointer and return if equal

   CMP R1, #0		@ first else-if
   MOVLT R0, #0		@ if n < 0, then return 0 by putting it into R0
   POPLT {PC}		@ go back to previous function call

   CMP R2, #0		@ second else-if, does m == 0?
   MOVEQ R0, #0		@ return 0 by putting 0 into R0 if n == 0
   POPEQ {PC}		@ restore stack pointer to previous call

   PUSH {R1}		@ put n onto stack
   PUSH {R2}		@ put m onto stack
   SUB R2, R2, #1	@ change second argument to (m-1)

   @@ AT THIS POINT, R1 SHOULD STILL HOLD n AND R2 SHOULD HOLD (m-1) @@

   BL _count_partitions	@ value of count_partitions(n, m-1) should be in R0

   POP {R2}		@ put original m back into second argument register
   POP {R1}		@ put original n back into first argument register

   SUB R1, R1, R2	@ calculate (n-m) for the left recursive call

   @@ AT THIS POINT, R1 SHOULD HOLD (n-m) and R2 SHOULD HOLD ORIGINAL M @@

   PUSH {R0}		@ backup the value returned by count_partitions(n, m-1)
   BL _count_partitions	@ value of count_partitions(n-m, m) should be in R0
   POP {R4}		@ restore the return value of the right recursive call
   ADD R0, R0, R4	@ add the previous return value to the new return value

   POP {PC}		@ restore the stack pointer and return
   
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