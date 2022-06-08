addi t0 x0 1
addi t1 t0 2
addi t2 t1 3
addi sp sp -8
sw t0 0(sp)
sw t1 4(sp)
addi t2 t2 1
lw t1 0(sp)
lw t0 4(sp)
addi sp sp 8