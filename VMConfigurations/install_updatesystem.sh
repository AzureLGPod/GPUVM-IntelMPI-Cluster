#!/bin/bash

sudo ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime
sudo apt-get update
sudo apt-get dist-upgrade -y
sudo reboot now