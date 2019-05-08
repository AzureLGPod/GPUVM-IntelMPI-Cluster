#!/bin/bash

##### Installing TensorFlow 1.13.1 ####
# Installing python3 dependencies
sudo apt update
sudo apt install -y python3-dev python3-pip
sudo pip3 install -U virtualenv

# Make folder for virtual environment
cd ~
mkdir ./venv
virtualenv --system-site-packages -p python3 ./venv
source ./venv/bin/activate

# Execute these command in virtual environment
pip install --upgrade pip
pip install tensorflow-gpu==1.13.1
# Checking the version
python -c 'import tensorflow as tf; print(tf.__version__)'
# Checking GPU with tf
python -c "import tensorflow as tf; tf.enable_eager_execution(); print(tf.reduce_sum(tf.random_normal([1000, 1000])))"