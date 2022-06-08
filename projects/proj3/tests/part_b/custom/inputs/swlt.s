addi t0 x0 1
addi t1 t0 2
addi t2 t1 3
addi sp sp -8
add s0 x0 sp
addi s0 s0 4
swlt t0 100(sp)
swlt t2 0(s0)
lw t2 0(sp)
lw t0 0(s0)