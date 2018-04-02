_count_partitions:
   PUSH {LR}

   CMP R1, #0
   MOVEQ R0, #1
   POPEQ {PC}

   CMP R1, #0
   MOVLT R0, #0
   POPLT {PC}

   CMP R2, #0
   MOVEQ R0, #0
   POPEQ {PC}

   PUSH {R1}
   PUSH {R2}
   SUB R2, R2, #1

   BL _count_partitions

   POP {R2}
   POP {R1}
   SUB R1, R1, R2

   PUSH {R0}
   BL _count_partitions
   POP {R4}
   ADD R0, R0, R4

   POP {PC}