.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.
# =================================================================
argmax:

    # Prologue

    add t0, x0, x0  #size
    add t1, x0, x0  #temp for cmp
    add t3, x0, x0  #index
loop_start:
    beq t0, a1, loop_end
    lw t2, 0(a0)    #load array element
    blt t1, t2, loop_continue
    addi t0, t0, 1
    addi a0, a0, 4
    j loop_start




loop_continue:
    add t1, x0, t2
    add t3, t0, x0
    addi t0, t0, 1
    addi a0, a0, 4
    j loop_start


loop_end:
    add a0, x0, t3

    # Epilogue


    ret