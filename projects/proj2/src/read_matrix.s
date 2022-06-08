.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
#
# If you receive an fopen error or eof, 
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -28
	sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw ra, 24(sp)


    mv s0 a0
    mv s1 a1
    mv s2 a2

    li a0 8
    jal ra malloc

    mv s3 a0

    mv a1 s0
    li a2 0
    jal ra fopen
    li t0, -1
    beq t0, a0, exit_50

    mv s4 a0

    mv a1 s4
    mv a2 s3
    li a3 8
    jal ra fread
    li t0, 8
    bne a0, t0, exit_51

    lw t0, 0(s3)
    lw t1, 4(s3)
    mul a3, t0, t1
    slli a3, a3, 2

    mv a0 a3
    jal ra malloc
    mv s5 a0

    mv a1 s4
    mv a2 s5
    jal ra fread
    mv t0 a3
    bne a0, t0, exit_51

    mv a1 s4
    jal ra fclose
    li t0 -1
    beq a0 t0 exit_52

    # to return
    mv a0 s5

    #foolish!

    lw t0 0(s3)
    sw t0 0(s1)
    mv a1 s1

    lw t0 4(s3)
    sw t0 0(s2)
    mv a2 s2

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw ra, 24(sp)
    addi sp, sp, 28

    ret


exit_48:
    li a1, 48
    j exit2

exit_50:
    li a1, 50
    j exit2 

exit_51:
    li a1, 51
    j exit2

exit_52:
    li a1, 52
    j exit2           