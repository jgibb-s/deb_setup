#! /bin/bash

# Largely from https://wiki.debian.org/NvidiaGraphicsDrivers

#add contrib non-free to source.list
apt add
#confirm gcc installed

apt install linux-headers-amd64

gcc --version

apt install nvidia-detect
nvidia-detect

apt install cuda-toolkit nvidia-driver nvidia-smi

export PATH=/usr/local/cuda-12.6/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-12.6/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}


mkdir /etc/X11/xorg.conf.d/10-intel.conf
echo -e 'Section "Device"\n\tIdentifier "Intel GPU"\n\tDriver "intel"\nEndSection' > /etc/X11/xorg.conf.d/10-nvidia.conf
