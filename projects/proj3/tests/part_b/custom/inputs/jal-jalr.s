addi t0 t0 1
addi t1 t0 2
addi t2 t1 3
jal ra wxy
add t2 t2 t1
sub t2 t0 t1
jal ra end
wxy: mul t2 t2 t1
jalr x0 ra 4
end: addi t0 t0 524