# Installing Anaconda inside of Docker image
This repository is intended to provide baseline command to install Anaconda3 inside of the Docker image. 

## Getting Started
This repository is for testing for installing Anaconda3 5.0.1 in Docker image and install dependencies in virtual environment with conda and from pip. 

## Dockerfile
```bash
FROM nvidia/cuda:9.0-devel-ubuntu16.04 
RUN apt-get update && apt-get install -y --allow-downgrades --allow-change-held-packages --no-install-recommends \ 
    curl 
RUN cd /tmp \ 
    && curl -O https://repo.anaconda.com/archive/Anaconda3-5.0.1-Linux-x86_64.sh \ 
    && bash Anaconda3-5.0.1-Linux-x86_64.sh -b -p $HOME/anaconda3 \ 
    && echo "export PATH=/root/anaconda3/bin:$PATH" >> ~/.bashrc 
ENV PATH /root/anaconda3/bin:$PATH 
RUN    conda create -n tenv python=3.6 -y \ 
    && conda install -n tenv tensorflow-gpu=1.9.0 -y \ 
    && conda install -n tenv imageio=2.5.0 -y \ 
    && conda install -n tenv scikit-image=0.14.2 -y \ 
    && conda install -n tenv opencv=3.4.2 -y \ 
    && echo "source activate tenv" >> ~/.bashrc 
ENV PATH /root/anaconda3/envs/tenv/bin:$PATH 
RUN /bin/bash -c "source activate tenv && pip install \ 
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
    XlsxWriter==1.1.6"
```
## Acknowledgments

* Special thanks to CSA/TSP/CAT from Microsoft Korea for contribution 
