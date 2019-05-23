FROM nvidia/cuda:9.0-devel-ubuntu16.04
# Based on default horovod image

# TensorFlow version is tightly coupled to CUDA and cuDNN so it should be selected carefully
ENV TENSORFLOW_VERSION=1.12.0
ENV PYTORCH_VERSION=1.1.0
ENV CUDNN_VERSION=7.5.1.10-1+cuda9.0
ENV NCCL_VERSION=2.2.12-1+cuda9.0

# Python 2.7 or 3.5 is supported by Ubuntu Xenial out of the box
ARG python=3.5
ENV PYTHON_VERSION=${python}

RUN echo "deb http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list

RUN apt-get update && apt-get install -y --no-install-recommends --allow-downgrades --allow-change-held-packages \
        build-essential \
        cmake \
        git \
        curl \
        vim \
        wget \
        apt-utils \
        iputils-ping \
        ca-certificates \
        libcudnn7=${CUDNN_VERSION} \
        libnccl2=${NCCL_VERSION} \
        libnccl-dev=${NCCL_VERSION} \
        libjpeg-dev \
        libpng-dev \
        net-tools \
        libsm6 \
        libxext6 \
        python$PYTHON_VERSION \
        python$PYTHON_VERSION-dev \
        # Infiniband/RDMA
        cpio \
        libdapl2 \
        aria2 \
        libmlx4-1 \
        libmlx5-1 \
        librdmacm1 \
        libibverbs1 \
        libmthca1 \
        libdapl2 \
        dapl2-utils \
        ibverbs-utils\
        ibutils \
        numactl \
        fakeroot \
        dpkg-dev \
        openssh-client \
        openssh-server

# Intel MPI 2017.2.174 runtime 
# COPY l_mpi_2017.2.174.tgz /tmp
RUN cd /tmp \
    && aria2c -x 8 -s 8 http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/11334/l_mpi_2017.2.174.tgz \
    && tar zxvf l_mpi_2017.2.174.tgz \
    && sed -i -e 's/^ACCEPT_EULA=decline/ACCEPT_EULA=accept/g' /tmp/l_mpi_2017.2.174/silent.cfg \
    && sed -i -e 's/^ACTIVATION_TYPE=exist_lic/ACTIVATION_TYPE=serial_number/g' /tmp/l_mpi_2017.2.174/silent.cfg \
    && sed -i -e 's/^#ACTIVATION_SERIAL_NUMBER=snpat/ACTIVATION_SERIAL_NUMBER=VXVJ-B5K8RCSM/g' /tmp/l_mpi_2017.2.174/silent.cfg \
    && cd /tmp/l_mpi_2017.2.174 \
    && ./install.sh -s silent.cfg \
    && cd .. \
    && rm -rf l_mpi_2017.2.174* \
    && echo "source /opt/intel/impi/2017.2.174/bin64/mpivars.sh" >> ~/.bashrc \
    && echo "root hard memlock unlimited" >> /etc/security/limits.conf \ 
    && echo "root soft memlock unlimited" >> /etc/security/limits.conf \
    && /opt/intel/impi/2017.2.174/bin64/mpivars.sh

# Configure OpenSSH for root login without password
COPY ssh_config /root/.ssh/config
COPY id_rsa /root/.ssh/id_rsa
COPY id_rsa.pub /root/.ssh/id_rsa.pub

# Added sed modification for PermitRootLogin. (3rd)
RUN mkdir -p /var/run/sshd \
    && ssh-keygen -A \
    && sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config \
    && sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config \
    && sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config \
    && sed -i 's/#RSAAuthentication yes/RSAAuthentication yes/g' /etc/ssh/sshd_config \
    && sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config \
    && chmod 600 /root/.ssh/id_rsa \
    && chmod 600 /root/.ssh/id_rsa.pub \
    && chmod 600 /root/.ssh/config \
    && chmod 700 /root/.ssh \
    && cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

ENV PATH $PATH:/opt/intel/impi/2017.2.174/bin64

RUN ln -s /usr/bin/python${PYTHON_VERSION} /usr/bin/python

RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

# Install Anaconda
RUN cd /tmp \ 
    && aria2c -x 8 -s 8 https://repo.anaconda.com/archive/Anaconda3-5.0.1-Linux-x86_64.sh \ 
    && bash Anaconda3-5.0.1-Linux-x86_64.sh -b -p $HOME/anaconda3 \ 
    && echo "export PATH=/root/anaconda3/bin:$PATH" >> ~/.bashrc \
    && conda install tensorflow-gpu=${TENSORFLOW_VERSION} -y \ 
    && conda install imageio=2.5.0 -y \ 
    && conda install scikit-image=0.14.2 -y \ 
    && conda install opencv=3.4.2 -y \
    && pip install \
        # Merging with application dependencies
        keras \ 
        jupyter \
        ipykernel \
        toolz \
        align==0.0.5 \ 
        boto==2.49.0 \ 
        boto3==1.9.119 \ 
        botocore==1.12.119 \ 
        bz2file==0.98 \ 
        chardet==3.0.4 \ 
        docutils==0.14 \ 
        gensim==3.7.1 \ 
        idna==2.8 \ 
        jmespath==0.9.4 \ 
        nltk==3.4 \ 
        pandas==0.24.2 \ 
        Pillow==5.4.1 \ 
        requests==2.21.0 \ 
        ruamel.yaml==0.15.89 \ 
        s3transfer==0.2.0 \ 
        scikit-learn==0.20.3 \ 
        singledispatch==3.4.0.3 \ 
        sklearn==0.0 \ 
        smart-open==1.8.0 \ 
        urllib3==1.24.1 \ 
        XlsxWriter==1.1.6

# Install PyTorch
RUN PY=$(echo ${PYTHON_VERSION} | sed s/\\.//); \
    if [[ ${PYTHON_VERSION} == 3* ]]; then \
        pip install http://download.pytorch.org/whl/cu90/torch-${PYTORCH_VERSION}-cp${PY}-cp${PY}m-linux_x86_64.whl; \
    else \
        pip install http://download.pytorch.org/whl/cu90/torch-${PYTORCH_VERSION}-cp${PY}-cp${PY}mu-linux_x86_64.whl; \
    fi; \
    pip install torchvision

# Install Horovod, temporarily using CUDA stubs
RUN ldconfig /usr/local/cuda-9.0/targets/x86_64-linux/lib/stubs && \
        /bin/bash -c "source /opt/intel/impi/2017.2.174/bin64/mpivars.sh" && \
    # HOROVOD_GPU_ALLREDUCE=NCCL HOROVOD_WITH_TENSORFLOW=1 pip install --no-cache-dir horovod==0.13.2 && \
    HOROVOD_WITH_TENSORFLOW=1 pip install --no-cache-dir horovod==0.15.2 && \
    ldconfig

# Set default NCCL parameters
RUN echo NCCL_DEBUG=INFO >> /etc/nccl.conf && \
    echo NCCL_SOCKET_IFNAME=^docker0 >> /etc/nccl.conf

# Download benchmarks
RUN git clone https://github.com/tensorflow/benchmarks && \
    cd benchmarks && \
    git checkout 3b90c14fb2bf02ca5d27c188aee878663229a0a7

# Update ib0 ip address with eth1 address in /etc/dat.conf 
COPY update_ib0_ip.sh /root/update_ib0_ip.sh
RUN chmod +x /root/update_ib0_ip.sh \
    && echo "./update_ib0_ip.sh" >> ~/.bashrc 

WORKDIR "/benchmarks"

# set up sshd on port 23
EXPOSE 23
CMD ["/usr/sbin/sshd", "-D", "-p", "23"]
