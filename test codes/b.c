#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <sys/syscall.h>

#define sz sizeof(int)*536870912
#define SYSCALL_NUMBER 326

int main(){
	int *arr;
	unsigned int i=0,j;
	arr = (int*)malloc(sz);
	memset(arr,0,sz);
	syscall(SYSCALL_NUMBER,arr);
	for(j=0; j<50; j++)
	{
		arr[i]+=2;
		usleep(5000);
		i+=4096;
	}
	syscall(SYSCALL_NUMBER,arr);

	for(j=0; j<50; j++)
	{
		arr[i]+=2;
		usleep(5000);
		i+=4096;
	}
	syscall(SYSCALL_NUMBER,arr);
	return 0;
}
