.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # 
    # If there are an incorrect number of command line args,
    # this function returns with exit code 49.
    #
    # Usage:
    #   main.s -m -1 <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    addi sp sp -52 
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw s5 20(sp)
    sw s6 24(sp)
    sw s7 28(sp)
    sw s8 32(sp)
    sw s9 36(sp)
    sw s10 40(sp)
    sw s11 44(sp)
    sw ra 48(sp)

    blt a0 x0 exit_49

    mv s0 a0
    mv s1 a1
    mv s2 a2

	# =====================================
    # LOAD MATRICES
    # =====================================






    # Load pretrained m0
    li a0 8
    jal malloc
    mv a1 a0
    addi a2 a0 4
    lw t0 4(s1)
    mv a0 t0

    jal read_matrix
    mv s3 a0     #s3 for m0
    lw t0 0(a1)
    mv s4 t0     #m0 rows
    lw t0 0(a2)
    mv s5 t0     #m0 columns

   


    # Load pretrained m1
    li a0 8
    jal malloc
    mv a1 a0
    addi a2 a0 4
    lw t0 8(s1)
    mv a0 t0

    jal read_matrix
    mv s6 a0     #s6 for m1
    lw t0 0(a1)
    mv s7 t0     #m1 rows
    lw t0 0(a2)
    mv s8 t0     #m2 columns


    


    # Load input matrix
    li a0 8
    jal malloc
    mv a1 a0
    addi a2 a0 4
    lw t0 12(s1)
    mv a0 t0

    jal read_matrix
    mv s9 a0      #s9 for input
    lw t0 0(a1)
    mv s10 t0     #input rows
    lw t0 0(a2)
    mv s11 t0     #input columns


    




    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    mul t0 s4 s11  # t0 elements
    slli t0 t0 2   # t0 bytes
    mv a0 t0
    jal malloc
    mv s0 a0
    
    mv a0 s3
    mv a1 s4
    mv a2 s5
    mv a3 s9
    mv a4 s10
    mv a5 s11
    mv a6 s0
    jal matmul


    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    mv a0 s0
    mul a1 s4 s11
    jal relu



    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    mul t0 s4 s8  # t0 elements
    slli t0 t0 2   # t0 bytes
    mv a0 t0
    jal malloc
    mv s3 a0
    
    mv a0 s6
    mv a1 s7
    mv a2 s8
    mv a3 s0
    mv a4 s4
    mv a5 s11
    mv a6 s3
    jal matmul



    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix

    lw t0 16(s1)
    mv a0 t0
    mv a1 s3
    mv a2 s4
    mv a3 s8
    jal write_matrix


    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0 s3
    mul a1 s4 s8
    jal argmax



    # Print classification
    mv a1 a0
    jal print_int



    # Print newline afterwards for clarity
    li a1 '\n'
    jal ra print_char

    mv a0 s3

    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    lw s6 24(sp)
    lw s7 28(sp)
    lw s8 32(sp)
    lw s9 36(sp)
    lw s10 40(sp)
    lw s11 44(sp)
    lw ra 48(sp)
    addi sp sp 52

    ret

exit_49:
    li a1 49
    j exit2    