##### install_intel_mpi_2017.2.174.sh  ######################
#!/bin/bash

#install dependencies
sudo apt install -y aria2 libdapl2 libmlx4-1

#download Intel 2017.2.174 and install
cd /tmp
aria2c -x 16 -s 16 http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/11334/l_mpi_2017.2.174.tgz
tar zxvf l_mpi_2017.2.174.tgz
sed -i -e 's/^ACCEPT_EULA=decline/ACCEPT_EULA=accept/g' /tmp/l_mpi_2017.2.174/silent.cfg
sed -i -e 's/^ACTIVATION_TYPE=exist_lic/ACTIVATION_TYPE=serial_number/g' /tmp/l_mpi_2017.2.174/silent.cfg
sed -i -e 's/^#ACTIVATION_SERIAL_NUMBER=snpat/ACTIVATION_SERIAL_NUMBER=VXVJ-B5K8RCSM/g' /tmp/l_mpi_2017.2.174/silent.cfg
cd /tmp/l_mpi_2017.2.174
sudo ./install.sh -s silent.cfg
cd ..
rm -rf l_mpi_2017.2.174*
echo "source /opt/intel/impi/2017.2.174/bin64/mpivars.sh" >> ~/.bashrc
source /opt/intel/impi/2017.2.174/bin64/mpivars.sh

# sudo vi /etc/waagent.conf, changing value for following two items
# OS.EnableRDMA=y 
# OS.UpdateRdmaDriver=y
sudo sed -i -e 's/^# OS.EnableRDMA=y/OS.EnableRDMA=y/g' /etc/waagent.conf
sudo sed -i -e 's/^# OS.UpdateRdmaDriver=y/OS.UpdateRdmaDriver=y/g' /etc/waagent.conf

#sudo vi /etc/security/limits.conf, adding following users with unlimited memlock
#root hard memlock unlimited
#root soft memlock unlimited
#gpuadmin hard memlock unlimited
#gpuadmin soft memlock unlimited

sudo sh -c 'echo "root hard memlock unlimited" >> /etc/security/limits.conf'
sudo sh -c 'echo "root soft memlock unlimited" >> /etc/security/limits.conf'
sudo sh -c 'echo "gpuadmin hard memlock unlimited" >> /etc/security/limits.conf'
sudo sh -c 'echo "gpuadmin soft memlock unlimited" >> /etc/security/limits.conf'

cd ~
ssh-keygen -A
ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

#~/.ssh/config에 StricktHostKeyChecking no 만하거나
#host 10.* 
# StrictHostKeyChecking no
sh -c 'echo "StrictHostKeyChecking no" >> ~/.ssh/config'

## Manually conduct ping test on both node.
#/opt/intel/impi/2017.2.174/bin64/mpirun -ppn 2 -n 2 -hosts 10.2.1.4,10.2.1.5 -env I_MPI_FABRICS=dapl -env I_MPI_DAPL_PROVIDER=ofa-v2-ib0 -env I_MPI_DYNAMIC_CONNECTION=0 /opt/intel/impi/2017.2.174/bin64/IMB-MPI1 pingpong

#######################################