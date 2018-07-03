#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <sys/syscall.h>
#include <sys/mman.h>

#define sz sizeof(char)*4096
#define PINNING_NUM 1
#define SYSCALL_NUMBER 326

int main(){
	char *arr;
	unsigned int i=0,j;
	arr = (char*)malloc(sz*8);
	memset(arr,0,sz);
	syscall(SYSCALL_NUMBER,arr);
	for(i=0; i<PINNING_NUM; i++){
		if(cudaHostRegister(arr+(i*4096),sz,0)!=0){
			printf("%d: pinning error!\n",getpid());
			return 0;
		}
	}
	syscall(SYSCALL_NUMBER,arr);
	return 0;
}
