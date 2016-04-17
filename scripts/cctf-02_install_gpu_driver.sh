#!/bin/bash

###################################################################
### ClassCat(R) Deep Learning Service
### Copyright (C) 2016 ClassCat(R) Co.,Ltd. All righs Reserved.
###################################################################

# --- HISTORY -----------------------------------------------------
# 22-mar-16 : rc 0xff.
# 08-mar-16 : beta 3.
# 07-mar-16 : beta 2 fixed.
# 06-mar-16 : typo fixed.
# 03-mar-16 : beta.
# 03-mar-16 : changed the url.
# 02-mar-16 : fixed.
# 29-feb-16 : created.
# -----------------------------------------------------------------


. ../conf/gpu_common.conf


function check_if_continue () {
  local var_continue

  echo -ne "About to install a GPU driver for ClassCat Deep Learning service. Continue ? (y/n) : " >&2

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
  echo -e  "\t\t\x1b[22;34m@Install GPU\x1b[m: release: rc 0xff (03/22/2016)"
  # echo -e  ""
}


function confirm () {
  local var_continue

  echo ""
  echo -ne "Make sure to set ../conf/\x1b[22;34mgpu_common.conf\x1b[m. Press return to continue (or ^C to exit) : " >&2

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
### DRM Driver
###

function install_drm_driver () {
  s3cmd get s3://cctf-classcat-com/ubuntu-kernel/drm.ko.3.13.0-${KERNEL_REVISION}-generic drm.ko

  mkdir -p /lib/modules/3.13.0-${KERNEL_REVISION}-generic/kernel/drivers/gpu/drm

  install -o root -g root -m 0644 drm.ko /lib/modules/3.13.0-${KERNEL_REVISION}-generic/kernel/drivers/gpu/drm

  insmod /lib/modules/3.13.0-${KERNEL_REVISION}-generic/kernel/drivers/gpu/drm/drm.ko

  if [ "$?" != 0 ]; then
    echo "Script aborted. insmod drm.ko failed."
    exit 1
  fi
}


###
### NVIDIA Driver
###

function install_nvidia_driver () {
  wget http://us.download.nvidia.com/XFree86/Linux-x86_64/352.63/NVIDIA-Linux-x86_64-352.63.run

  chmod +x NVIDIA-Linux-x86_64-352.63.run 

  ./NVIDIA-Linux-x86_64-352.63.run

  if [ "$?" != 0 ]; then
    echo "Script aborted. ./NVIDIA-Linux-x86_64-352.63.run failed."
    exit 1
  fi

}



###################
### ENTRY POINT ###
###################

init


#### Working Dir should be set to /mnt.
mkdir -p /mnt/nvidia
cd /mnt/nvidia


### Install Drivers.
install_drm_driver

install_nvidia_driver


### Clean Up ###

cd /mnt
rm -rf nvidia


### Finally ###

echo ""
echo "###############################################################"
echo "# Script execution has been completed successfully."
echo "#"
echo "# 1) To enable DRM/NVIDIA driver, please reboot the instance :"
echo "#        # sync && reboot "
echo "#"
echo "# 2) Then, run cctf-03_install_cuda_and_cudnn.sh."
echo "###############################################################"
echo ""


exit 0

### End of Script ###
