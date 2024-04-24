#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void matrixMultiplication(float* A, float* B, float* C, int m, int n, int k) {
    #pragma acc parallel loop collapse(2) present(A, B, C)
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < k; j++) {
            float sum = 0.0;
            for (int l = 0; l < n; l++) {
                sum += A[i * n + l] * B[l * k + j];
            }
            C[i * k + j] = sum;
        }
    }
}

int main() {
    int m = 1000;   
    int n = 1000;   
    int k = 1000;  

    
    srand(time(NULL));

    
    float* A = (float*)malloc(m * n * sizeof(float));
    for (int i = 0; i < m * n; i++) {
        A[i] = (float)rand() / RAND_MAX;  
    }

    
    float* B = (float*)malloc(n * k * sizeof(float));
    for (int i = 0; i < n * k; i++) {
        B[i] = (float)rand() / RAND_MAX; 
    }

    
    float* C = (float*)malloc(m * k * sizeof(float));

    clock_t start_time = clock();
    matrixMultiplication(A, B, C, m, n, k);
    clock_t end_time = clock();

    double execution_time = (double)(end_time - start_time) / CLOCKS_PER_SEC;
    printf("Execution Time: %.2f seconds\n", execution_time);

    
    free(A);
    free(B);
    free(C);

    return 0;
}
