.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   The order of error codes (checked from top to bottom):
#   If the dimensions of m0 do not make sense, 
#   this function exits with exit code 2.
#   If the dimensions of m1 do not make sense, 
#   this function exits with exit code 3.
#   If the dimensions don't match, 
#   this function exits with exit code 4.
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# =======================================================
matmul:

    # Error checks
    li t0, 1
    blt a1, t0, exit_2
    blt a2, t0, exit_2
    blt a4, t0, exit_3
    blt a5, t0, exit_3
    bne a2, a4, exit_4

    # Prologue
    addi sp, sp, -32
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw ra, 28(sp)

    mv s0 a0
    mv s1 a1
    mv s2 a2
    mv s3 a3
    mv s4 a4
    mv s5 a5
    mv s6 a6

    li t0 0  #t0 = i
    li t1 0  #t1 = j

outer_loop_start:
    beq t0, s1, outer_loop_end

    j inner_loop_start


inner_loop_start:
    beq t1, s5, inner_loop_end
    mv a0 s0
    mv a1 s3
    mv a2 s2
    li a3 1
    mv a4 s5

    addi sp, sp, -8
    sw t0, 0(sp)
    sw t1, 4(sp)
    jal ra dot

    sw a0, 0(s6)
    addi s6, s6, 4

    lw t0, 0(sp)
    lw t1, 4(sp)
    addi sp, sp, 8

    addi s3, s3, 4
    addi t1, t1, 1

    j inner_loop_start




inner_loop_end:
    addi t0, t0, 1
    li t1 0

    li t2 4
    mul t2, s2, t2
    add s0, s0, t2

    li t2 4
    mul t2, s5, t2
    sub s3, s3, t2

    j outer_loop_start

outer_loop_end:


    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw ra, 28(sp)
    addi sp, sp, 32
    
    ret

exit_2:
    li a0, 17
    li a1, 2
    ecall

exit_3:
    li a0, 17
    li a1, 3
    ecall   

exit_4:
    li a0, 17
    li a1, 4
    ecall 