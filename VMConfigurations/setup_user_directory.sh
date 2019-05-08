#!/bin/bash

# Create a mount point
sudo mkdir -p /home/nfsshare
sudo apt update
sudo apt install -y nfs-common
sudo mount -t nfs 10.0.2.20:/var/nfsshare /home/nfsshare
sudo sh -c 'echo "10.0.2.20:/var/nfsshare /home/nfsshare nfs defaults 0 0" >> /etc/fstab'


# Add a user and logoff gpuadmin until user home directory is chaged.
sudo su
useradd gpuadmin2
passwd gpuadmin2
adduser gpuadmin2 sudo
exit
exit

# Login as gpuadmin2
sudo usermod -d /home/nfsshare/gpuadmin gpuadmin
exit

# Login as gpuadmin1
sudo userdel -r gpuadmin2
