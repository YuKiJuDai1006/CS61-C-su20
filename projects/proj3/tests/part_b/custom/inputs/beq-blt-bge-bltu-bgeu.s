addi t0 t0 1
addi t1 t0 2
addi t2 t1 3
bne t1 t2 wxy
addi s1 s1 1
addi s0 s0 1
addi s0 s0 1
addi s0 s0 1
wxy: addi t0 t0 1
beq t0 t1 wxt
addi s0 s0 1
addi s0 s0 1
addi s0 s0 1
wxt: addi t0 t0 1006
blt t1 t0 wxyy
mul s0 s0 t2
addi s0 s0 1
addi s0 s0 1
addi s0 s0 1
addi s0 s0 1
wxyy: addi t1 t1 2000
bge t1 t2 wxyyy
addi s0 s0 1
addi s0 s0 1
addi s0 s0 1
addi s0 s0 1
addi s0 s0 1
wxyyy: sll t0 t0 t2
bltu t0 t1 wxtt
addi s0 s0 2
addi s0 s0 1
addi s0 s0 1
addi s0 s0 1
addi s0 s0 1
wxtt: sll t2 t2 t2
bgeu t0 t2 end
addi s0 s0 3
addi s0 s0 1
addi s0 s0 1
addi s0 s0 1
addi s0 s0 1
addi s0 s0 1
end: sub t0 t0 t1 