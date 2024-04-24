#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void matrixMultiplication(float* A, float* B, float* C, int m, int n, int k, int tile_size) {
    #pragma acc parallel loop collapse(2) present(A, B, C)
    for (int ii = 0; ii < m; ii += tile_size) {
        for (int jj = 0; jj < k; jj += tile_size) {
            for (int i = ii; i < ii + tile_size; i++) {
                for (int j = jj; j < jj + tile_size; j++) {
                    float sum = 0.0;
                    for (int l = 0; l < n; l++) {
                        sum += A[i * n + l] * B[l * k + j];
                    }
                    C[i * k + j] = sum;
                }
            }
        }
    }
}

int main() {
    int m = 1000;   
    int n = 1000;   
    int k = 1000;   
    int tile_size = 32;  

    
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
    matrixMultiplication(A, B, C, m, n, k, tile_size);
    clock_t end_time = clock();

    double execution_time = (double)(end_time - start_time) / CLOCKS_PER_SEC;
    printf(" Time: %.2f s\n", execution_time);

    return 0;
    //ok
}
