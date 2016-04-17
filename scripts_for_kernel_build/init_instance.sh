#!/bin/bash

###################################################################
### Copyright (C) 2016 ClassCat(R) Co.,Ltd. All righs Reserved. ###
###################################################################

# --- HISTORY -----------------------------------------------------
# 22-mar-16 : rc 0xff.
# 01-mar-16 : use build_kernel.conf instead of init_instance.conf
# 01-mar-16 : msg out.
# 29-feb-16 : created.
# -----------------------------------------------------------------


. ../conf_for_kernel_build/build.conf


function check_if_continue () {
  local var_continue

  echo -ne "About to init an instance for kernel build. Continue ? (y/n) : " >&2

  read var_continue
  if [ -z "$var_continue" ] || [ "$var_continue" != 'y' ]; then
    echo -e "Exit the install program."
    echo -e ""
    exit 1
  fi
}


function init_instance() {

  ### Basic ###
  apt-get update
  apt-get -y upgrade
  apt-get -y dist-upgrade

  apt-get install -y ntp

  ### /etc/hosts to disable ipv6 ###
  cp -p /etc/hosts /etc/hosts.orig
  echo "127.0.0.1\tlocalhost\n" > /etc/hosts

  ### BACKUP ###
  cp -a /etc /etc.ec2.orig


  ### SWAP ###

  cp -p /etc/rc.local /etc/rc.local.orig

cat <<_EOB_ > /etc/rc.local
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

SWAPFILENAME=/swap.img
SIZE=${SWAP_SIZE}

fallocate -l \$SIZE \$SWAPFILENAME && mkswap \$SWAPFILENAME && swapon \$SWAPFILENAME

exit 0
_EOB_

}


###
### INIT
###

function init () {
  check_if_continue

  init_instance
}



###
### S3CMD
###

function install_and_config_s3cmd () {
  apt-get install -y s3cmd

  install -o root -g root ../assets/s3cfg.north-east-1 /root/.s3cfg

  # change delimiter to space.
  sed -i.tmpl -e "s ^access_key\s*=.* access_key=${S3CMD_ACCESS_KEY} g" /root/.s3cfg
  sed -i      -e "s ^secret_key\s*=.* secret_key=${S3CMD_SECRET_KEY} g" /root/.s3cfg
  #sed -i.tmpl -e "s/^access_key\s*=.*/access_key = ${S3CMD_ACCESS_KEY}/g" /root/.s3cfg
  #sed -i      -e "s/^secret_key\s*=.*/secret_key = ${S3CMD_SECRET_KEY}/g" /root/.s3cfg
}


###################
### ENTRY POINT ###
###################

init

install_and_config_s3cmd


### 

echo ""
echo "To enable a swap file, please reboot the instance."
echo ""

exit 0


### End of Script ###
