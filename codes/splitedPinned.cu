#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#define LEN 134217728

int main(void){
	char* h_arr = (char*)malloc(LEN * 4);
	char* d_arr; cudaMalloc(&d_arr, LEN * 4);
	int page_size = 1 << 12;
	unsigned long i = 0;
	cudaHostRegister(h_arr, LEN * 4, 0);
	//cudaHostRegister(h_arr, LEN, 0);
	//cudaHostRegister(h_arr + LEN, LEN, 0);
	//cudaHostRegister(h_arr + LEN * 2, LEN, 0);
	//cudaHostRegister(h_arr + LEN * 3, LEN, 0);
	/*
	for(i = 0; i < LEN * 4; i += page_size)
		cudaHostRegister(h_arr + page_size * i, page_size, 0);
	memset(h_arr, 1, LEN * 4);
	*/

	cudaMemcpy(d_arr, h_arr, LEN * 4, cudaMemcpyHostToDevice);
	//cudaMemcpy(d_arr, h_arr, LEN, cudaMemcpyHostToDevice);
	//cudaMemcpy(d_arr + LEN, h_arr + LEN, LEN, cudaMemcpyHostToDevice);
	//cudaMemcpy(d_arr + LEN * 2, h_arr + LEN * 2, LEN, cudaMemcpyHostToDevice);
	//cudaMemcpy(d_arr + LEN * 3, h_arr + LEN * 3, LEN, cudaMemcpyHostToDevice);
	/*
	for(i = 0; i < LEN * 4; i += page_size)
		cudaMemcpy(d_arr + page_size * i, h_arr + page_size * i, page_size, cudaMemcpyHostToDevice);
	*/

	cudaHostUnregister(h_arr);
	//cudaHostUnregister(h_arr + LEN);
	//cudaHostUnregister(h_arr + LEN * 2);
	//cudaHostUnregister(h_arr + LEN * 3);
	/*
	for(i = 0; i < LEN * 4; i += page_size)
		cudaHostUnregister(h_arr + page_size * 3);
	*/
	free(h_arr);
	cudaFree(d_arr);

	return 0;
}
