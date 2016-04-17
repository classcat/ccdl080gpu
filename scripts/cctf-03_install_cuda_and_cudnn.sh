#!/bin/bash

###################################################################
### ClassCat(R) Deep Learning Service
### Copyright (C) 2016 ClassCat(R) Co.,Ltd. All righs Reserved.
###################################################################

# --- HISTORY -----------------------------------------------------
# 22-mar-16 : rc 0xff
# 22-mar-16 : account: theano, chainer
# 08-mar-16 : beta 3.
# 07-mar-16 : beta 2 fixed.
# 03-mar-16 : Beta.
# 03-mar-16 : changed the url.
# 02-mar-16 : fixed.
# 29-feb-16 : created.
# -----------------------------------------------------------------


function check_if_continue () {
  local var_continue

  echo -ne "About to install CUDA & cuDNN for ClassCat Deep Learning service. Continue ? (y/n) : " >&2

  read var_continue
  if [ -z "$var_continue" ] || [ "$var_continue" != 'y' ]; then
    echo -e "Exit the install program."
    echo -e ""
    exit 1
  fi
}


function show_banner () {
  clear

  echo -e  ""
  echo -en "\x1b[22;36m"
  echo -e  "\tClassCat(R) Deep Learning Service"
  echo -e  "\tCopyright (C) 2016 ClassCat Co.,Ltd. All rights reserved."
  echo -en "\x1b[m"
  echo -e  "\t\t\x1b[22;34m@Install CUDA & cuDNN\x1b[m: release: rc 0xff (03/22/2016)"
  # echo -e  ""
}


function confirm () {
  local var_continue

  echo ""
  echo -ne "Press return to continue (or ^C to exit) : " >&2

  read var_continue
}



###
### INIT
###

function init () {
  check_if_continue

  show_banner

  confirm
}


###
### CUDA 7.5
###

function install_cuda () {
  wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1404/x86_64/cuda-repo-ubuntu1404_7.0-28_amd64.deb

  dpkg -i cuda-repo-ubuntu1404_7.0-28_amd64.deb

  apt-get update

  apt-get install -y cuda-7-5
}


###
### cuDNN v4
###

function install_cudnn () {
  s3cmd get s3://cctf-classcat-com/nvidia/cudnn-7.0-linux-x64-v4.0-prod.tgz

  tar xfz ./cudnn-7.0-linux-x64-v4.0-prod.tgz 

  mkdir /usr/local/cudnn-r4

  cp -r cuda /usr/local/cudnn-r4
}



###
### Configure BashRC
###

function config_bashrc_for_cuda () {
  echo "" >> /root/.bashrc
  echo "export CUDA_HOME=/usr/local/cuda"  >> /root/.bashrc
  echo "export PATH=$PATH:\$CUDA_HOME/bin" >> /root/.bashrc
  echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$CUDA_HOME/lib64:/usr/local/cudnn-r4/cuda/lib64" >> /root/.bashrc

  echo "" >> /home/tensorflow/.bashrc
  echo "export CUDA_HOME=/usr/local/cuda"  >> /home/tensorflow/.bashrc
  echo "export PATH=$PATH:\$CUDA_HOME/bin" >> /home/tensorflow/.bashrc
  echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$CUDA_HOME/lib64:/usr/local/cudnn-r4/cuda/lib64" >> /home/tensorflow/.bashrc

  echo "" >> /home/theano/.bashrc
  echo "export CUDA_HOME=/usr/local/cuda"  >> /home/theano/.bashrc
  echo "export PATH=$PATH:\$CUDA_HOME/bin" >> /home/theano/.bashrc
  echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$CUDA_HOME/lib64:/usr/local/cudnn-r4/cuda/lib64" >> /home/theano/.bashrc

  echo "" >> /home/torch/.bashrc
  echo "export CUDA_HOME=/usr/local/cuda"  >> /home/torch/.bashrc
  echo "export PATH=$PATH:\$CUDA_HOME/bin" >> /home/torch/.bashrc
  echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$CUDA_HOME/lib64:/usr/local/cudnn-r4/cuda/lib64" >> /home/torch/.bashrc

  #echo "" >> /home/tensorflow3/.bashrc
  #echo "export CUDA_HOME=/usr/local/cuda"  >> /home/tensorflow3/.bashrc
  #echo "export PATH=$PATH:\$CUDA_HOME/bin" >> /home/tensorflow3/.bashrc
  #echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$CUDA_HOME/lib64:/usr/local/cudnn-r4/cuda/lib64" >> /home/tensorflow3/.bashrc
}



###################
### ENTRY POINT ###
###################

init


#### Working Dir should be set to /mnt.
mkdir -p /mnt/nvidia2
cd /mnt/nvidia2


### Install CUDA & cuDNN

install_cuda

install_cudnn

config_bashrc_for_cuda


### Clean up

cd /mnt

rm -rf nvidia2


### Finally ###

echo ""
echo "################################################################"
echo "# Script execution has been completed successfully."
echo "#"
echo "# 1) To enable CUDA 7.5 & cnDNN v4, please reboot the instance"
echo "#        # sync && reboot "
echo "#"
echo "# 2) Then, run cctf04-device_query.sh."
echo "################################################################"
echo ""


exit 0
