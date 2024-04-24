Function matrixMultiplication(A, B, C, m, n, k):
    #pragma acc parallel loop collapse(2) present(A, B, C)
    For i from 0 to m-1:
        For j from 0 to k-1:
            Set sum to 0.0
            For l from 0 to n-1:
                Update sum by adding A[i * n + l] * B[l * k + j]
            Set C[i * k + j] to sum
            
Declare variables: A, B, C, m, n, k
Set values of m, n, and k
Allocate memory for matrix A of size m*n
Initialize matrix A with random values
Allocate memory for matrix B of size n*k
Initialize matrix B with random values
Allocate memory for matrix C of size m*k

Record start time
Perform matrix multiplication using matrixMultiplication function with matrices A, B, and C, and dimensions m, n, k
Record end time

Calculate execution time as (end_time - start_time) / CLOCKS_PER_SEC

Print "Execution Time: " concatenated with execution time in seconds

Free memory allocated for matrices A, B, and C
