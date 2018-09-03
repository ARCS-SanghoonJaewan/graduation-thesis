#include <stdlib.h>
#include <stdio.h>

int main(int argc, char *argv[]){
	unsigned long long mb = 1024*1024*8;
	FILE *fp = fopen("run.sh","w+");
	int i,size=1;
	fprintf(fp,"#!/bin/sh\n");

	for(i=1; i<=10;i++){
		fprintf(fp,"echo \"nvprof ./a %dMB\"\n",size);
		fprintf(fp,"nvprof ./a %lld 2>%dMB.txt\n\n",mb,size);
		size *=2;
		mb*=2;
	}
	for(i=1; i<=2;i++){
		fprintf(fp,"echo \"nvprof ./a %dGB\"\n",i);
		fprintf(fp,"nvprof ./a %lld 2>%dGB.txt\n\n",mb,i);
		mb*=2;
	}
	return 0;
}
