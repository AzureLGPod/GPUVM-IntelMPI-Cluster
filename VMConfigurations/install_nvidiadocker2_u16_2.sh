#!/bin/bash

# Download images
# Login to nvidia developer repository
docker login nvcr.io -u '$oauthtoken' -p Nmo3MzcxcjM4MzM0cjAyZzQyYXZwcWw2NHI6N2IyOGJjMDUtYzNhYy00MDQ4LTg1YmMtZDZjZjYzMjQxZmJl
nohup docker pull nvcr.io/nvidia/tensorflow:18.12-py3 &
# Download horovod image 
nohup docker pull horovod/horovod:0.16.1-tf1.12.0-torch1.0.0-mxnet1.4.0-py3.5 & 

# monitor the job with ps -ef and tail -f nohup.out
tail -f nohup.out