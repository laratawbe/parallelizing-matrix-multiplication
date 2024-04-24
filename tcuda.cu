#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define MATRIX_SIZE 1000
#define TILE_SIZE 16

__global__ void matrixMultiplication(float *matrixA, float *matrixB, float *matrixC, int n);


int main(){
    float *a, *b, *c;
    int n = MATRIX_SIZE;
    int size = n * n * sizeof(float);

    a = (float *)malloc(size);
    b = (float *)malloc(size);
    c = (float *)malloc(size);

    srand(time(NULL));
    for (int i = 0; i < n * n; ++i){
        a[i] = (float)rand() / RAND_MAX;
        b[i] = (float)rand() / RAND_MAX;
    }

    float *d_a, *d_b, *d_c;
    cudaMalloc((void **)&d_a, size);

    cudaMalloc((void **)&d_b, size);
    cudaMalloc((void **)&d_c, size);
    cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);

    cudaMemcpy(d_b, b, size, cudaMemcpyHostToDevice);
    dim3 dimGrid((n + TILE_SIZE - 1) / TILE_SIZE, (n + TILE_SIZE - 1) / TILE_SIZE);
    dim3 dimBlock(TILE_SIZE, TILE_SIZE);
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

__global__ void matrixMultiplication(float *matrixA, float *matrixB, float *matrixC, int n){
    float partialSum = 0.00;
    __shared__ float sharedMatrixA[TILE_SIZE][TILE_SIZE];

    __shared__ float sharedMatrixB[TILE_SIZE][TILE_SIZE];
    for (int tile = 0; tile < (n + TILE_SIZE - 1) / TILE_SIZE; tile++){
    
        int tileRow = blockIdx.y * TILE_SIZE + threadIdx.y;
        int tileCol = tile * TILE_SIZE + threadIdx.x;

        if (tileRow < n && tileCol < n){
            sharedMatrixA[threadIdx.y][threadIdx.x] = matrixA[tileRow * n + tileCol];
        }
        else{
            sharedMatrixA[threadIdx.y][threadIdx.x] = 0.0;
        }
        tileRow = tile * TILE_SIZE + threadIdx.y;
        tileCol = blockIdx.x * TILE_SIZE + threadIdx.x;

        if (tileRow < n && tileCol < n){
            sharedMatrixB[threadIdx.y][threadIdx.x] = matrixB[tileRow * n + tileCol]; //review
        }
            
        else{
            sharedMatrixB[threadIdx.y][threadIdx.x] = 0.0;

        }
            
        __syncthreads();

        for (int k = 0; k < TILE_SIZE; k++){
            partialSum += sharedMatrixA[threadIdx.y][k] * sharedMatrixB[k][threadIdx.x];
        }
        __syncthreads();
    }

    int row = blockIdx.y * TILE_SIZE + threadIdx.y;

    int col = blockIdx.x * TILE_SIZE + threadIdx.x;
    if (row < n && col < n){
        matrixC[row*n + col] = partialSum;
    }
}

