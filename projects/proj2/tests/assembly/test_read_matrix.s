.import ../../src/read_matrix.s
.import ../../src/utils.s

.data
file_path: .asciiz "su20-proj2-starter/tests/inputs/test_read_matrix/test_input.bin"

.text
main:
    # Read matrix into memory
    li a0 8
    jal ra malloc
    addi a1, a0, 0
    addi a2, a0, 4
    la a0 file_path
    jal ra read_matrix



    # Print out elements of matrix
    li a1 3
    li a2 3
    jal ra print_int_array


    # Terminate the program
    jal exit