#!/bin/bash

# Ref: https://medium.com/@zhanwenchen/install-cuda-10-1-and-cudnn-7-5-0-for-pytorch-on-ubuntu-18-04-lts-9b6124c44cc
# Installing Cuda 10.0.130 with toolkits for Ubuntu 16.04
# CUDA_REPO_PKG=cuda-repo-ubuntu1604_9.2.148-1_amd64.deb
CUDA_REPO_PKG=cuda-repo-ubuntu1604_10.0.130-1_amd64.deb
wget -O /tmp/${CUDA_REPO_PKG} http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/${CUDA_REPO_PKG}
sudo dpkg -i /tmp/${CUDA_REPO_PKG}
sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub 
rm -f /tmp/${CUDA_REPO_PKG}
sudo apt-get update
sudo apt-get -y install cuda-10-0

# Add following two lines CUDA Config to ~/.bashrc
echo 'export PATH=/usr/local/cuda-10.0/bin:/usr/local/cuda-10.0/NsightCompute-1.0${PATH:+:${PATH}}' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda-10.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc
source ~/.bashrc
# nvcc --version is now possible

# Test 1 and 2 is optional. Compile could take up to 15 mins. 
#cd /usr/local/cuda-10.0/samples
#sudo make -j32

# Test1. Device Query
#/usr/local/cuda-10.0/samples/bin/x86_64/linux/release/deviceQuery

# Test2. Run a computation-based test
#/usr/local/cuda-10.0/samples/bin/x86_64/linux/release/matrixMulCUBLAS

##### Installing cuDNN 7.5.1.10 for CUDA 10.0 ###########
cd /tmp
# the runtime library
sudo apt-get install -y --allow-downgrades --allow-change-held-packages --no-install-recommends aria2
aria2c -x 8 -s 8 https://gpufarmpublic.blob.core.windows.net/publicrepo/libcudnn7_7.5.1.10-1%2Bcuda10.0_amd64.deb
# the developer library
aria2c -x 8 -s 8 https://gpufarmpublic.blob.core.windows.net/publicrepo/libcudnn7-dev_7.5.1.10-1%2Bcuda10.0_amd64.deb
# code samples
aria2c -x 8 -s 8 https://gpufarmpublic.blob.core.windows.net/publicrepo/libcudnn7-doc_7.5.1.10-1%2Bcuda10.0_amd64.deb

sudo dpkg -i libcudnn7_7.5.1.10-1+cuda10.0_amd64.deb
sudo dpkg -i libcudnn7-dev_7.5.1.10-1+cuda10.0_amd64.deb
sudo dpkg -i libcudnn7-doc_7.5.1.10-1+cuda10.0_amd64.deb

# Conduct MNIST test. 
cd /usr/src/cudnn_samples_v7/mnistCUDNN/
sudo make -j32 clean && sudo make -j32
./mnistCUDNN

sudo reboot now