/* txz5041_p3.s */

.global main
.func main

main:
    BL _scanf
    MOV R4, R0
    MOV R1, R0
    PUSH {R1}
    BL _scanf
    POP {R1}
    MOV R5, R0
    MOV R2, R0
    MOV R0, #0
    BL _part
    BL _printf
    B main

_part:
    PUSH {LR}
    
    CMP R1, #0
    ADDEQ R0, #1
    POPEQ {PC}
    
    CMP R1, #0
    POPMI {PC}
    
    CMP R2, #0
    POPEQ {PC}
   
    PUSH {R1}
    SUB R1, R1, R2
    BL _part
    POP {R1}
    PUSH {R2}
    
    SUB R2, R2, #1
    BL _part
    
    POP {R2}

    POP {PC}
    
 _printf:
    PUSH {LR}
    MOV R3, R2
    MOV R2, R1
    MOV R1, R0
    LDR R0, =printf_str     @ R0 contains formatted string address
    @MOV R1, R1              @ R1 contains printf argument (redundant line)
    BL printf               @ call printf
    POP {PC}              @ return

_scanf:
    PUSH {LR}                @ store LR since scanf call overwrites
    PUSH {R1}
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {R1}
    POP {PC}                 @ return
  
  
.data
format_str:     .asciz      "%d"
printf_str:     .asciz      "There are %d partitions using %d to %d\n"