#include <stdlib.h>
#include <stdio.h>

int main(int argc, char *argv[]){
	char *arr;
	char *d_arr;
	unsigned long long size = atoll(argv[1]);
	cudaMalloc(&d_arr,size);
	cudaHostAlloc(&arr,size,cudaHostAllocDefault);
	if(!arr){
		printf("malloc error\n");
		return 0;
	}
	cudaMemcpy(d_arr,arr,size,cudaMemcpyHostToDevice);

	cudaFree(d_arr);

	return 0;
}
