#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <pthread.h>
#include <semaphore.h>
#include <cuda.h>

struct pro_arg{
	void* src;
	size_t count;
};

struct con_arg{
	void* dst;
	size_t count;
};

struct unused_element{
	size_t index;
	void* buf;
}

static size_t queue_size;

static sem_t used_empty;
static sem_t used_full;
static pthread_mutex_t used_mutex = PTHREAD_MUTEX_INITIALIZER;
static size_t used_put_index = 0;
static size_t used_get_index = 0;
static void** used;

static sem_t unused_empty;
static sem_t unused_full;
static pthread_mutex_t unused_mutex = PTHREAD_MUTEX_INITIALIZER;
static size_t unused_put_index = 0;
static size_t unused_get_index = 0;
static struct unused_element* unused;

static pthread_mutex_t pro_index_mutex = PTHREAD_MUTEX_INITIALIZER;
static size_t pro_num;
static size_t pro_index = 0;

static size_t buf_size;
static void** buf;

void used_put(void* used_one){
	used[used_put_index] = used_one;
	used_put_index = (used_put_index + 1) % queue_size;
}

void* used_get(){
	void* ret = used[used_get_index];
	used_get_index = (used_get_index + 1) % queue_size;
	return ret;
}

void unused_put(struct unused_element unused_one){
	unused[unused_put_index] = unused_one;
	unused_put_index = (unused_put_index + 1) % queue_size;
}

struct unused_element unused_get(){
	struct unused_element ret = unused[unused_get_index];
	unused_get_index = (unused_get_index + 1) % queue_size;
	return ret;
}

int constructBuf(size_t b_size, size_t p_num, size_t q_size){
	cudaError_t ret;

	buf_size = b_size;
	pro_num = p_num;
	queue_size = q_size;

	if(0 != sem_init(&used_empty, 0, 0))
		return -1;
	if(0 != sem_init(&used_full, 0, queue_size))
		return -1;
	if(0 != sem_init(&unused_empty, 0, queue_size))
		return -1;
	if(0 != sem_init(&unused_full, 0, 0))
		return -1;
	
	buf = (void**)malloc(sizeof(void*) * queue_size);
	used = (void**)malloc(sizeof(void*) * queue_size);
	unused = (struct unused_element*)malloc(sizeof(struct unused_element) * queue_size);
	if(buf == NULL)
		return -1;
	if(used == NULL)
		return -1;
	if(unused == NULL)
		return -1;

	for(size_t i = 0; i < queue_size; i++){
		ret = cudaHostAlloc(&buf[i], buf_size, cudaHostAllocDefault | cudaHostAllocWriteCombined);
		if(ret != cudaSuccess){
			switch(ret){
				case cudaErrorInvalidValue:
					errno = EINVAL;
					break;
				case cudaErrorMemoryAllocation:
					errno = ENOMEM;
					break;
				case cudaErrorHostMemoryAlreadyRegistered:
					errno = EADDRINUSE;
					break;
				case cudaErrorNotSupported:
					errno = ENOSYS;
					break;
			}
			return -1;
		}
	}

	for(size_t i = 0; i < queue_size; i++)
		used_put(buf[i]);

	return 0;
}

int destroyBuf(){
	cudaError_t ret;

	if(0 != sem_destroy(&used_empty))
		return -1;
	if(0 != sem_destroy(&used_full))
		return -1;
	if(0 != sem_destroy(&unused_empty))
		return -1;
	if(0 != sem_destroy(&unused_full))
		return -1;

	free(used);
	free(unused);

	for(size_t i = 0; i < queue_size; i++){
		ret = cudaFreeHost(buf[i]);
		if(ret != cudaSuccess){
			switch(ret){
				case cudaErrorInvalidValue:
					errno = EINVAL;
					break;
				case cudaErrorHostMemoryNotRegistered:
					errno = EFAULT;
					break;
			}
			return -1;
		}
	}

	free(buf);

	return 0;	
}

void* producer(void* arg){
	struct pro_arg* t_pro_arg = (struct pro_arg*)arg;
	void* src = t_pro_arg->src;
	size_t count = t_pro_arg->count;
	size_t target_index = 0;
	void* target_buf;
	struct unused_element target;
	bool is_end = false;

	while(true){
		pthread_mutex_lock(&pro_index_mutex);
		if(pro_index < count){
			target_index = pro_index;
			++pro_index;
			is_end = false;
		}
		else
			is_end = true;
		pthread_mutex_unlock(&pro_index_mutex);
		if(is_end == true)
			break;

		sem_wait(&used_full);
		pthread_mutex_lock(&used_mutex);
		target_buf = used_get();
		pthread_mutex_unlock(&used_mutex);
		sem_post(&used_empty);

		memcpy(target_buf, src + target_index * buf_size; buf_size);

		sem_wait(&unused_empty);
		pthread_mutex_lock(&unused_mutex);
		target.index = target_index;
		target.buf = target_buf;
		unused_put(target);
		pthread_mutex_unlock(&unused_mutex);
		sem_post(&unused_full);
	}
}

void* consumer(void* arg){
	struct con_arg* t_con_arg = (struct con_arg*)arg;
	void* dst = t_con_arg->dst;
	size_t count = t_con_arg->count;
	size_t target_index = 0;
	void* target_buf;
	struct unused_element target;

	for(size_t i = 0; i < count; i++){
		sem_wait(&unused_full);
		pthread_mutex_lock(&unused_mutex);
		target = unused_get();
		target_index = target.index;
		target_buf = target.buf;
		pthread_mutex_unlock(&unused_mutex);
		sem_post(&unused_empty);

		cudaMemcpy(dst + target_index * buf_size, target_buf, buf_size, cudaMemcpyHostToDevice);

		sem_wait(&used_empty);
		pthread_mutex_lock(&used_mutex);
		used_put(target_buf);
		pthread_mutex_unlock(&used_mutex);
		sem_post(&used_full);
	}
}

void cudaMemcpyFixed(void* dst, void* src, size_t count, enum cudaMemcpyKind kind){
	pthread_t* pro_t = (pthread_t*)malloc(sizeof(pthread_t) * pro_num);
	pthread_t con_t;
	struct pro_arg* t_pro_arg = (struct pro_arg*)malloc(sizeof(struct pro_arg) * pro_num);
	struct con_arg t_con_arg;

	pro_index = 0;

	for(size_t i = 0; i < pro_num; i++){
		t_pro_arg[i].src = src;
		t_pro_arg[i].count = count / buf_size;
		if(pthread_create(&pro_t[i], NULL, producer, (void*)&t_pro_arg[i]) < 0){
			perror("producer thread create error : ");
			exit(0);
		}
	}

	t_con_arg.dst = dst;
	t_con_arg.count = count / buf_size;
	if(pthread_create(&con_t, NULL, consumer, (void*)&t_con_arg) < 0){
		perror("consumer thread create error : ");
		exit(0);
	}

	for(size_t i = 0; i < pro_num; i++){
		pthread_join(pro_t[i], NULL);
		printf("pro_t %lu is end\n", i);
	}
	pthread_join(con_t, NULL);
	printf("con_t is end\n");

	cudaMemcpy(dst + count - count % buf_size, src + count - count % buf_size, count % buf_size, kind);
	
	free(pro_t);
	free(t_pro_arg);
}
