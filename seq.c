#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define M 2
#define N 2
#define K 2

void matrixMultiplication(float *A, float *B, float *C, int m, int n, int k) {
    clock_t start_time = clock();
    for (int i = 0; i < m; ++i) {
        for (int j = 0; j < k; ++j) {
            float sum = 0.0;
            for (int p = 0; p < n; ++p) {
                sum += A[i * n + p] * B[p * k + j];
            }
            C[i * k + j] = sum;
        }
    }
    clock_t end_time = clock();
    double elapsed_time = (double)(end_time - start_time) / CLOCKS_PER_SEC;
    printf("Elapsed Time: %.7f seconds\n", elapsed_time);
}


int main() {
    float *A, *B, *C;
    int size_A = M * N * sizeof(float);
    int size_B = N * K * sizeof(float);
    int size_C = M * K * sizeof(float);

    A = (float *)malloc(size_A);
    B = (float *)malloc(size_B);
    C = (float *)malloc(size_C);

    
    srand(time(NULL)); 
    for (int i = 0; i < M * N; ++i) {
        A[i] = (float)rand() / RAND_MAX; // Random float between 0 and 1
    }
    for (int i = 0; i < N * K; ++i) {
        B[i] = (float)rand() / RAND_MAX; // Random float between 0 and 1
    }



    matrixMultiplication(A, B, C, M, N, K);

    free(A);
    free(B);
    free(C);

    return 0;
}
