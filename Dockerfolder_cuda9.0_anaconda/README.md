# CUDA 9.0 based Docker image for Ubuntu 16.04
This Docker image is intended for NC24rs_v3 with Intel MPI to support Horovod for TensorFlow.

## Docker image configuration
Please follow from step 1 through 4 on the nodes, where the nodes are participating in same cluster.

1. Building Docker image.
```bash
$ docker build -t cuda9.0/impi .
```
2. Run the container in background with following command.
This container will listen on port 23 for incoming SSH connection.
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
  The result should be similar to this, where 172.16.X.X IP address is shown.
  ```bash
  ofa-v2-ib0 u2.0 nonthreadsafe default libdaplofa.so.2 dapl.2.0 "172.16.1.3 0" ""
  ```
5. Executing the mpirun inside of the container.
```bash
$ mpirun -ppn 4 -n 8 -host 10.2.1.4,10.2.1.5 -env I_MPI_DEBUG=9 -env I_MPI_HYDRA_DEBUG=on -env CUDA_VISIBLE_DEVICES=0,1,2,3 -env I_MPI_FABRICS=dapl -env I_MPI_DAPL_PROVIDER=ofa-v2-ib0 -env I_MPI_DYNAMIC_CONNECTION=0 python tensorflow_mnist_estimator.py
```

Command lines to run container and test traing session.
```
docker build -t hvd-cuda9.0 .

nvidia-docker run -d --device=/dev/infiniband/rdma_cm --device=/dev/infiniband/uverbs0 --net=host -v ~/docker:/workspace --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 --name cuda9image hvd-cuda9.0

docker exec -it cuda9image /bin/bash

cd ~
./update_ib0_ip.sh
cat /etc/dat.conf | head -n 21 | tail -n 1

mpirun -ppn 4 -n 8 -host 10.0.1.4,10.0.1.5 -env I_MPI_DEBUG=9 -env I_MPI_HYDRA_DEBUG=on -env I_MPI_FABRICS=shm:dapl -env I_MPI_DAPL_PROVIDER=ofa-v2-ib0 -env I_MPI_DYNAMIC_CONNECTION=0 python tensorflow_mnist_estimator.py
```
