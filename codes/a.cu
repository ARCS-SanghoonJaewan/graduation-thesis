#include <stdio.h>
#include <unistd.h>
#include <sys/syscall.h>

#include <sys/mman.h>

#define handle_error(msg) \
	do { perror(msg); exit(EXIT_FAILURE); } while (0)

#define SHELL_FMT "cat /proc/%ld/maps"
#define CMD_SIZE (sizeof(SHELL_FMT) + 20)
//#define SYSCALL_NUMBER 333
#define SYSCALL_NUMBER 326

int main(){
	int *arr;
	arr = (int*)malloc(sizeof(int)*100000);
	int i;
	char cmd[CMD_SIZE];
	for(i=0; i<4096; i++){
		arr[i] = i;
	}
	printf("Address of arr is: %p\n",arr);
	syscall(SYSCALL_NUMBER, arr);
	//mlock(arr,sizeof(int)*4096);

	snprintf(cmd, CMD_SIZE, SHELL_FMT, (long)getpid());
	system(cmd);

	cudaHostRegister(arr,sizeof(int)*4096,0);
	for(i=0; i<4096; i++){
		arr[i] = i+1;
	}
	printf("Address of arr is: %p\n",arr);

	printf("After mpretect()\n");
	system(cmd);

	syscall(SYSCALL_NUMBER, arr);
	return 0;
}
