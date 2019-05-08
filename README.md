# GPUVM-IntelMPI-Cluster
Docker image for NC24rs_v3 with Intel MPI for Horovod and TensorFlow

## Docker image configuration
Please follow from step 1 through 4 on the nodes, where the nodes are acting as a single cluster.

1. Building Docker image.
```bash
$ docker build -t cuda9.0/impi .
```
2. Run the container in background with following command.
```bash
$ nvidia-docker run -d --device=/dev/infiniband/rdma_cm --device=/dev/infiniband/uverbs0 --net=host -v ~/nfsshare:/workspace --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 --name cuda9image cuda9.0/impi
```
3. Get inside of the container.
```bash
$ docker exec -it cuda9image /bin/bash
```
4. Execute /root/update_ib0_ip.sh to update ib0 with IP address of eth1 at 21st line of /etc/dat.conf
```bash
$ cd ~
$ ./update_ib0_ip.sh
$ cat /etc/dat.conf | head -n 21 | tail -n 1
```
  The result should be similar to this
  ```bash
  ofa-v2-ib0 u2.0 nonthreadsafe default libdaplofa.so.2 dapl.2.0 "172.16.1.3 0" ""
  ```
5. Executing the command with Intel MPI inside of the container.
```bash
$ mpirun -ppn 4 -n 8 -host 10.2.1.4,10.2.1.5 -env I_MPI_DEBUG=9 -env I_MPI_HYDRA_DEBUG=on -env CUDA_VISIBLE_DEVICES=0,1,2,3 -env I_MPI_FABRICS=dapl -env I_MPI_DAPL_PROVIDER=ofa-v2-ib0 -env I_MPI_DYNAMIC_CONNECTION=0 python tensorflow_mnist_estimator.py
```

