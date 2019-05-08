# Azure Compute NC24rs_v3 configuration steps
These commands are targed for Ubuntu 16.04 on NC24rs_v3, which has 4 v100 Tesla cards installed with Infiniband support.
This Infiniband supports RDMA and IP over IB is not supported. The RDMA is supported by Intel MPI and not by OpenMPI.

## Prerequisites. 
Following steps are only required if you want to put user home directory on NFS.

1. Create a mount point for NFS, add a second user with sudo privilege so this user can change first user's home directory.
   Follow the code provided and manually type the commands.
```bash
$ cat setup_user_directory.sh
```

## Installing CUDA 10.0 based packages.

2. Set time zone to Korea, run dist-upgrade to detect all GPU cards on the system, and finally reboot the system.
```bash
$ ./install_updatesystem.sh
```

3. Install CUDA 10.0 and cuDNN 7.5.1.10.
```bash
$ ./install_cudnn_7.5.1.10_for_cuda10.0_u16.sh
```

4. Install NVIDIA Docker v2, give user permission to execute docker by assigning to docker group, and finally logoff the user.
   You need to login again to make the group assignment to take effect.
```bash
$ ./install_nvidiadocker2_u16_1.sh
```

5. Download NVIDIA TensorFlow 18.12 image and horovod image.
```bash
$ ./install_nvidiadocker2_u16_2.sh
```

6. Install TensorFlow 1.13.1 with GPU support.
```bash
$ ./install_tensorflow_1.13.1_u16.sh
```

7. Install Horovod 0.16.1
```bash
$ ./install_horovod_0.16.1_u16.sh 
```
Note: HOROVOD_GPU_ALLREDUCE=NCCL works on the distributed workload is within the same node. 
If workload needs to be distributed beyond a single node with Intel MPI, this option must not be given. 
For multi-GPU with multi-node enviroment, install with following command.
```bash 
HOROVOD_WITH_TENSORFLOW=1 pip install --no-cache-dir horovod==0.16.1 
```

8. Install Intel MPI 2017.2.174 
```bash
$ ./install_intel_mpi_2017.2.174.sh 
```
