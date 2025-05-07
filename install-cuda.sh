#! /bin/bash

# Largely from
# https://wiki.debian.org/NvidiaGraphicsDrivers
# https://docs.nvidia.com/cuda/cuda-installation-guide-linux/
# https://docs.nvidia.com/datacenter/tesla/driver-installation-guide/index.html

#add contrib non-free to source.list
sudo add-apt-repository non-free
sudo add-apt-repository contrib
sudo apt update

# Check for gpu
lspci -nn | egrep -i "3d|display|vga"

#prompt continue?

# Pre-reqs
sudo apt install linux-headers-amd64 gcc nvidia-detect

#confirm gcc installed
gcc --version

nvidia-detect

sudo apt install firmware-misc-nonfree nvidia-driver nvidia-smi nvidia-cuda-toolkit

export PATH=/usr/local/cuda-12.6/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-12.6/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}


touch /etc/X11/xorg.conf.d/10-intel.conf
echo -e 'Section "Device"\n\tIdentifier "Intel GPU"\n\tDriver "intel"\nEndSection' > /etc/X11/xorg.conf.d/10-intel.conf
