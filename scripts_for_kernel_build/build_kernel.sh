#!/bin/bash

###################################################################
### Copyright (C) 2016 ClassCat(R) Co.,Ltd. All righs Reserved. ###
###################################################################

# --- HISTORY -----------------------------------------------------
# 22-mar-16 : rc 0xff.
# 03-mar-16 : changed the url.
# 29-feb-16 : created.
# -----------------------------------------------------------------


. ../conf_for_kernel_build/build.conf


function check_if_continue () {
  local var_continue

  echo -ne "About to build kernel. Continue ? (y/n) : " >&2

  read var_continue
  if [ -z "$var_continue" ] || [ "$var_continue" != 'y' ]; then
    echo -e "Exit the install program."
    echo -e ""
    exit 1
  fi
}


check_if_continue

apt-get install -y build-essential libncurses5-dev

apt-get install -y linux-source

cd /usr/src/linux-source-3.13.0

tar xfj linux-source-3.13.0.tar.bz2

cd /usr/src/linux-source-3.13.0/linux-source-3.13.0

cp -p /boot/config-3.13.0-${KERNEL_REVISION}-generic ./.config

time make -j ${NUMBER_OF_CORES}

if [ "$?" != 0 ]; then
  echo "Script aborted. make -j ${NUMBER_OF_CORES} failed."
  exit 1
fi



###
### Store it to s3.
###

s3cmd put drivers/gpu/drm/drm.ko s3://cctf-classcat-com/ubuntu-kernel/drm.ko.3.13.0-${KERNEL_REVISION}-generic

if [ "$?" != 0 ]; then
  echo "Script aborted. s3cmd put failed."
  exit 1
fi


###

echo ""
echo "Done."
echo ""



### End of Script ###
