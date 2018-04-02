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