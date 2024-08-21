#include <curand_kernel.h>
#include <iostream>

__global__ void guard(float *A) {
    int tid = blockDim.x * blockIdx.x + threadIdx.x;
    curandState state;
    curand_init(23497214, tid, 0, &state);
    printf("guard kernel starts\n");
    float out = 0;
    while (true) {
        int id = curand(&state) % (3 << 19);
        out += A[id];
        if (id == 0) break;
    }
    A[0] = out;
}

int main(void)
{
    int numElements = 3 << 19;
    size_t size = numElements * sizeof(float);
    float *d_A = NULL;
    cudaMalloc((void **)&d_A, size);

    // Launch the guard Kernel
    int threadsPerBlock = 32;
    int blocksPerGrid = 1;
    guard<<<blocksPerGrid, threadsPerBlock>>>(d_A);
    cudaError_t err = cudaDeviceSynchronize();
    if (err != cudaSuccess) {
        printf("CUDA Error: %s\n", cudaGetErrorString(err));
    }

    return 0;
}

