#!/bin/sh
echo "nvprof ./a 1MB"
nvprof ./pathfinder 1024 2048 20 2>1MBAlloc.txt

echo "nvprof ./a 2MB"
nvprof ./pathfinder 2048 2048 20 2>2MBAlloc.txt

echo "nvprof ./a 4MB"
nvprof ./pathfinder 4096 2048 20 2>4MBAlloc.txt

echo "nvprof ./a 8MB"
nvprof ./pathfinder 4096 4096 20 2>8MBAlloc.txt

echo "nvprof ./a 16MB"
nvprof ./pathfinder 4096 8192 20 2>16MBAlloc.txt

echo "nvprof ./a 32MB"
nvprof ./pathfinder 8192 8192 20 2>32MBAlloc.txt

echo "nvprof ./a 64MB"
nvprof ./pathfinder 8192 16384 20 2>64MBAlloc.txt

echo "nvprof ./a 128MB"
nvprof ./pathfinder 16384 16384 20 2>128MBAlloc.txt

echo "nvprof ./a 256MB"
nvprof ./pathfinder 16384 32768 20 2>256MBAlloc.txt

echo "nvprof ./a 512MB"
nvprof ./pathfinder 32768 32768 20 2>512MBAlloc.txt

echo "nvprof ./a 1GB"
nvprof ./pathfinder 32768 65536 20 2>1GBAlloc.txt

echo "nvprof ./a 2GB"
nvprof ./pathfinder 65536 65536 20 2>2GBAlloc.txt

