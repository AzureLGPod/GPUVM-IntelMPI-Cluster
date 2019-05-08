####### Install_NCCL_2.4.2_U16.sh  ########################
#!/bin/bash
sudo dpkg -i nccl-repo-ubuntu1604-2.4.2-ga-cuda10.0_1-1_amd64.deb
sudo apt update
sudo apt install libnccl2=2.4.2-1+cuda10.0 libnccl-dev=2.4.2-1+cuda10.0
###################################
