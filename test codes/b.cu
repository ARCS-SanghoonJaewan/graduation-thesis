#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <sys/syscall.h>
#include <sys/mman.h>

#define sz sizeof(int)*100
#define SYSCALL_NUMBER 326
#define PG_SIZE 64

int main(){
	int *arr;
	unsigned int i=0,j;
	arr = (int*)malloc(sz);
	memset(arr,0,sz);
	/*
	if(cudaHostRegister(arr,sz,0)!=0){
		printf("%d: pinning error!\n",getpid());
		return 0;
	}
	*/
	   if(mlock(arr,sz)!=0){
	   printf("%d: pinning error!\n",getpid());
	   return 0;
	   }
	syscall(SYSCALL_NUMBER,arr);
	for(j=0; j<50; j++)
	{
		arr[i]+=2;
		usleep(5000);
		i+=PG_SIZE;
	}
	syscall(SYSCALL_NUMBER,arr);

	for(j=0; j<50; j++)
	{
		arr[i]+=2;
		usleep(5000);
		i+=PG_SIZE;
	}
	syscall(SYSCALL_NUMBER,arr);
	return 0;
}
