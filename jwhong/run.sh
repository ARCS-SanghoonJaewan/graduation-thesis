#!/bin/sh
echo "nvprof ./a 1MB"
nvprof -o 1MB.nvvp ./a 8388608

echo "nvprof ./a 2MB"
nvprof -o 2MB.nvvp ./a 16777216

echo "nvprof ./a 4MB"
nvprof -o 4MB.nvvp ./a 33554432

echo "nvprof ./a 8MB"
nvprof -o 8MB.nvvp ./a 67108864

echo "nvprof ./a 16MB"
nvprof -o 16MB.nvvp ./a 134217728

echo "nvprof ./a 32MB"
nvprof -o 32MB.nvvp ./a 268435456

echo "nvprof ./a 64MB"
nvprof -o 64MB.nvvp ./a 536870912

echo "nvprof ./a 128MB"
nvprof -o 128MB.nvvp ./a 1073741824

echo "nvprof ./a 256MB"
nvprof -o 256MB.nvvp ./a 2147483648

echo "nvprof ./a 512MB"
nvprof -o 512MB.nvvp ./a 4294967296

echo "nvprof ./a 1GB"
nvprof -o 1GB.nvvp ./a 8589934592

echo "nvprof ./a 2GB"
nvprof -o 2GB.nvvp ./a 17179869184

