    .global main
    .func main
main:
    PUSH {LR}
    LDR R0, =string
    MOV R1, #10
    MOV R2, #15
    MOV R3, #25
    BL printf
    POP {PC}

_exit:
    MOV PC, LR

.data
string:
    .asciz "If you add %d and %d you get %d.\n"