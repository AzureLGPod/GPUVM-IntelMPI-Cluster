###########install_horovod 0.16.1 ubuntu 16 ###########
#!/bin/bash
pip uninstall -y horovod
HOROVOD_GPU_ALLREDUCE=NCCL HOROVOD_WITH_TENSORFLOW=1 pip install --no-cache-dir horovod==0.16.1
#######################################################