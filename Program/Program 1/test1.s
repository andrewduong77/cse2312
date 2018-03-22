/* multiply two numbers R0=R1*R2	*/

    .global  main
    .func main
main:

    PUSH {LR}
    LDR R0, =string	@ R0 points to string
    MOV R1, #20		@ R1=20
    MOV R2, #5		@ R2=5
    MUL R3, R1, R2	@ R3=R1*R2
    BL printf
    POP {PC}

    MOV R7, #1		@ exit through syscall
    SWI 0

_exit:
    MOV PC, LR		@ simple exit


.data
string:
    .asciz "%d * %d = %d\n"