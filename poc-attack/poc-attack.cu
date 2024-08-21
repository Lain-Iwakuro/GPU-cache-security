#include <curand_kernel.h>
#include <iostream>
#define N 1
#include <fstream>
#include <sstream>
#include <vector>

#define ROWS 32
#define COLS 16
// #define LDCG 1
#define REPEAT 50
#define REPEAT_IN 5

__global__ void monitor(float *A, int* M, float *C) {
    int tid = blockDim.x * blockIdx.x + threadIdx.x;
    curandState state;
    curand_init(46346232, tid, 0, &state);
    clock_t start, end;

    if (tid > 0) return;

    int line = 2;

    int idx0 = M[line * 16 + 0];
    int idx1 = M[line * 16 + 1];
    int idx2 = M[line * 16 + 2];
    int idx3 = M[line * 16 + 3];
    int idx4 = M[line * 16 + 4];
    int idx5 = M[line * 16 + 5];
    int idx6 = M[line * 16 + 6];
    int idx7 = M[line * 16 + 7];
    int idx8 = M[line * 16 + 8];
    int idx9 = M[line * 16 + 9];
    int idx10 = M[line * 16 + 10];
    int idx11 = M[line * 16 + 11];
    int idx12 = M[line * 16 + 12];
    int idx13 = M[line * 16 + 13];
    int idx14 = M[line * 16 + 14];
    int idx15 = M[line * 16 + 15];

    float test = 0;

    // warm up
    float warm = 0;
    int size = 3 << 19, float_per_line = 16;
    if (tid == 0) {
        for (int k = 0; k < 3; k++) {
            for (int idx = 0; idx < size; idx += float_per_line) {
                warm += A[idx];
            }
        }
    }
    
    float out = 0;

#pragma unroll
    for (int k = 0; k < REPEAT; k++) {
        // put into cache
#pragma unroll
        for (int i = 0; i < REPEAT_IN; i++) {
            start = clock64();
            out += C[idx0];
            out += C[idx1];
            out += C[idx2];
            out += C[idx3];
            out += C[idx4];
            out += C[idx5];
            out += C[idx6];
            out += C[idx7];
            out += C[idx8];
            out += C[idx9];
            out += C[idx10];
            out += C[idx11];
            out += C[idx12];
            out += C[idx13];
            out += C[idx14];
            out += C[idx15];
            end = clock64();
            // printf("%f\n", (float)(end - start));
        }
        // __syncthreads();

        // access
        out += A[57696 - line * 32];
        // __syncthreads();


        // check
#pragma unroll
        for (int i = 0; i < REPEAT_IN; i++) {
            start = clock64();
            out += C[idx0];
            out += C[idx1];
            out += C[idx2];
            out += C[idx3];
            out += C[idx4];
            out += C[idx5];
            out += C[idx6];
            out += C[idx7];
            out += C[idx8];
            out += C[idx9];
            out += C[idx10];
            out += C[idx11];
            out += C[idx12];
            out += C[idx13];
            out += C[idx14];
            out += C[idx15];
            end = clock64();
            printf("%f\n", (float)(end - start));
        }
    }

    A[0] = out;
    A[1] = warm;
    A[2] = test;
}



int main() {
    std::ifstream file("../rev_set.txt");
    if (!file.is_open()) {
        std::cerr << "Error opening file" << std::endl;
        return EXIT_FAILURE;
    }

    // int array[ROWS][COLS];
    int *h_M = (int *)malloc(ROWS * COLS * sizeof(int));
    std::string line;
    for (int i = 0; i < ROWS && std::getline(file, line); ++i) {
        std::istringstream iss(line);
        std::string number;
        for (int j = 0; j < COLS && std::getline(iss, number, ','); ++j) {
            // array[i][j] = std::stoi(number);
            h_M[i * COLS + j] = std::stoi(number);
        }
    }

    file.close();

    // Print the array to verify
    // for (int i = 0; i < ROWS; ++i) {
    //     for (int j = 0; j < COLS; ++j) {
    //         // std::cout << array[i][j] << " ";
    //         std::cout << h_M[i * COLS + j] << " ";
    //     }
    //     std::cout << std::endl;
    // }

    int numElements = 3 << 19;
    size_t size = numElements * sizeof(float);
    float *h_A = (float *)malloc(size);
    float *h_C = (float *)malloc(size);

    // Initialize the host input vectors
    for (int i = 0; i < numElements; ++i)
    {
        h_A[i] = rand() / (float)RAND_MAX;
    }

    // Allocate the device input vector A
    float *d_A = NULL;
    cudaMalloc((void **)&d_A, size);

    // Allocate the device output vector C
    float *d_C = NULL;
    cudaMalloc((void **)&d_C, size);

    int *d_M = NULL;
    cudaMalloc((void **)&d_M, ROWS * COLS * sizeof(int));

    cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_M, h_M, ROWS * COLS * sizeof(int), cudaMemcpyHostToDevice);

    // Launch the Kernel
    int threadsPerBlock = 32;
    int blocksPerGrid = 1;
    monitor<<<blocksPerGrid, threadsPerBlock>>>(d_A, d_M, d_C);

    cudaMemcpy(h_C, d_C, size, cudaMemcpyDeviceToHost);

    // Free device global memory
    cudaFree(d_A);
    cudaFree(d_C);

    // Free host memory
    free(h_A);
    free(h_C);

    // printf("Done\n");
    return 0;
}
