.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
#
# If the length of the vector is less than 1, 
# this function exits with error code 8.
# ==============================================================================
relu:
    # Prologue


    add t0, x0, x0
loop_start:
    beq t0, a1, loop_end
    lw t1, 0(a0)
    blt t1, x0, loop_continue
    addi t0, t0, 1
    addi a0, a0, 4
    j loop_start



loop_continue:
    sw x0, 0(a0)
    addi t0, t0, 1
    addi a0, a0, 4
    j loop_start


loop_end:


    # Epilogue

    
	ret