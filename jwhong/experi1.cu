#include <stdlib.h>
#include <stdio.h>

int main(int argc, char *argv[]){
	char *arr;
	char *d_arr;
	unsigned long long size = atoll(argv[1]);
	arr = (char*)malloc(size);
	cudaMalloc(&d_arr,size);
	if(!arr){
		printf("malloc error\n");
		return 0;
	}

	cudaMemcpy(d_arr,arr,size,cudaMemcpyHostToDevice);

	free(arr);
	cudaFree(d_arr);

	return 0;
}
