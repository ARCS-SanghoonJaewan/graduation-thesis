#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/syscall.h>

#include <sys/mman.h>

//#define SYSCALL_NUMBER 333
#define SYSCALL_NUMBER 326

int main(){
	FILE *fd = fopen("addr.txt","w+");
	int *arr;
	int *cudaArr;

	arr = (int*)malloc(sizeof(int)*100000);
	cudaMalloc(&cudaArr, sizeof(int)*100000);
	int i;
	fprintf(fd,"Address of arr is: %p\n",arr);
	fprintf(fd,"Address of arr is: %p\n",&arr);
	for(i = 0; i < 100000; i++){
		arr[i] = i;
	}
	cudaHostRegister(arr,sizeof(int)*100000,0);
	cudaMemcpy(cudaArr, arr, sizeof(int)*100000, cudaMemcpyHostToDevice);

	syscall(SYSCALL_NUMBER,arr);
	cudaFree(cudaArr);

	return 0;
}
