#include <stdio.h>
#include <unistd.h>
#include <sys/syscall.h>

#include <sys/mman.h>

//#define SYSCALL_NUMBER 333
#define SYSCALL_NUMBER 326

int main(){
	int arr[1000000];
	int ret;
	int *a ;
	long int buf = 8642887680;
	a = buf;
	a = realloc(a,
	/*
	ret = syscall(SYSCALL_NUMBER,8624887690,256);
	printf("%d\n", ret);
	ret = syscall(SYSCALL_NUMBER,8624887690,512);
	printf("%d\n", ret);
	ret = syscall(SYSCALL_NUMBER,8644984832,256);
	printf("%d\n", ret);
	ret = syscall(SYSCALL_NUMBER,8644984832,512);
	printf("%d\n", ret);
	ret = syscall(SYSCALL_NUMBER,&arr,256);
	printf("%d\n", ret);
	*/
	ret = syscall(SYSCALL_NUMBER,8642887680,256);
	printf("%d\n", ret);
	ret = syscall(SYSCALL_NUMBER,8644984832,256);
	printf("%d\n", ret);
	ret = syscall(SYSCALL_NUMBER,arr,256);
	printf("%d\n", ret);
	return 0;
}
