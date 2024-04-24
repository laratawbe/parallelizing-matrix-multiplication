#include <stdio.h>
#include <stdlib.h>
#include <time.h>



// __global__ void matrixMultiplication(float *A, float *B, float *C, int m, int n, int k) {
//     int row = blockIdx.y * blockDim.y + threadIdx.y;
//     int col = blockIdx.x * blockDim.x + threadIdx.x;

//     if (row < m && col < k) {
//         float sum = 0.0;
//         for (int i = 0; i < n; i++) {
//             sum += A[row * n + i] * B[i * k + col];
//         }
//         C[row * k + col] = sum;
//     }
// }
__global__ void matrixMultiplication(float *a, float *b, float *c, int n);

int main(){
    int n = 1000;
    float *a, *b, *c;
    int size = n * n * sizeof(float);
    a = (float *)malloc(size);
    b = (float *)malloc(size);
    
    c = (float *)malloc(size);
    srand(time(NULL));
    for (int i = 0; i < n * n; i++){
        a[i] = (float)rand() / RAND_MAX;
        b[i] = (float)rand() / RAND_MAX;
    }

    float *d_a, *d_b, *d_c;
    cudaMalloc((void **)&d_a, size);
    cudaMalloc((void **)&d_b, size);

    cudaMalloc((void **)&d_c, size);
    cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, size, cudaMemcpyHostToDevice);

    dim3 dimGrid((n + 15) / 16, (n + 15) / 16);
    dim3 dimBlock(16, 16);
    clock_t start_time = clock();

    matrixMultiplication<<<dimGrid, dimBlock>>>(d_a, d_b, d_c, n);
    cudaDeviceSynchronize();

    clock_t end_time = clock();
    double elapsed_time = ((double)(end_time - start_time)) / CLOCKS_PER_SEC;
    printf("time: %.7f seconds\n", elapsed_time);

    cudaMemcpy(c, d_c, size, cudaMemcpyDeviceToHost);

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
    free(a);
    free(b);
    free(c);

    return 0;
}

__global__ void matrixMultiplication(float *a, float *b, float *c, int n){
    int row = blockIdx.y * blockDim.y + threadIdx.y;

    int col = blockIdx.x * blockDim.x + threadIdx.x;
    if (row  < n && col  < n){
        float sum = 0.0;

        for (int i = 0; i < n; i++){
            sum += a[row*n + i] * b[i*n + col];
        }
        c[row*n + col] = sum;
    }
}
