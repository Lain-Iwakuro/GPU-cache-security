#include <stdio.h>
#include <curand_kernel.h>

#define PRIME_REP 2
#define ACCESS_REP 2
#define CHECK_REP 5

// use this kernel to figure out which addresses map to the same set
__global__ void get_set(const float *A,  float *C, int numElements)
{
    int gid = blockDim.x * blockIdx.x + threadIdx.x;
    if (gid > 0) return;
    // printf("hello, world!\n");
    curandState state;
    curand_init(136782492, gid, 0, &state);
    clock_t start, end;

    int size = 3 << 19, float_per_line = 16;
    // int idx_start = 3 << 19;
    int idx_start = 0;
    int send_stride = 32;
    float out = 0, time;
    int candidate[CHECK_REP];
    int last_idx = 0;

    // warm_up
    float warm = 0;
    for (int k = 0; k < PRIME_REP; k++) {
        for (int idx = 0; idx < size; idx += float_per_line) {
            warm += A[idx];
        }
    }

    for (int send_idx = idx_start; send_idx < idx_start + size; send_idx += send_stride) {
#pragma unroll
        for (int k = 0; k < CHECK_REP; k++) {
            // printf("write A to L2 cache!\n");
#pragma unroll
            for (int j = 0; j < PRIME_REP; j++) {
                for (int idx = 0; idx < size; idx += float_per_line) {
                    out += A[idx];
                }
            }

            // printf("fit cache line at send_idx into cache!\n");
#pragma unroll
            for (int j = 0; j < ACCESS_REP; j++) {
                out += C[send_idx];
            }

            // printf("get the cache line that is gone!\n");
            for (int offset = 0; offset < size; offset += send_stride) {
                int recv_idx = (last_idx + offset) % size;
                start = clock64();
                out += A[recv_idx];
                end = clock64();
                time = (float)(end - start);
                // printf("%f\n", time);
                if (time > 350.0) {
                    // printf("%d, %f\n", recv_idx, time);
                    candidate[k] = recv_idx;
                    // last_idx = (recv_idx + size - 1024) % size;
                    last_idx = 0;
                    // printf("%d\n", candidate[k]);
                    break;
                }
            }
        }
        // verify
        printf("%d", send_idx);
        for (int k = 0; k < CHECK_REP - 1; k++) {
            if (candidate[k] == candidate[k + 1]) {
                printf(", %d", candidate[k]);
                break;
            }
        }
        printf("\n");
    }
    C[0] = out;
}

int main(void)
{
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

    // Copy the host input
    cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);

    // Launch the CUDA Kernel
    int threadsPerBlock = 32;
    int blocksPerGrid = 1;
    get_set<<<blocksPerGrid, threadsPerBlock>>>(d_A, d_C, numElements);

    // Copy the device result vector in device memory to the host result vector
    // in host memory.
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