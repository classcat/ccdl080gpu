#!/bin/bash

###################################################################
### ClassCat(R) Deep Learning Service
### Copyright (C) 2016 ClassCat(R) Co.,Ltd. All righs Reserved. ###
###################################################################

# --- HISTORY -----------------------------------------------------
# 22-mar-16 : created.
# -----------------------------------------------------------------


function check_if_continue () {
  local var_continue

  echo -ne "About to install torch for ClassCat Deep Learning service. Continue ? (y/n) : " >&2

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
  echo -e  "\t\t\x1b[22;34m@Device Query\x1b[m: release: rc 0xff (03/22/2016)"
  # echo -e  ""
}


function confirm () {
  local var_continue

  echo ""
  echo -ne "This script must be run as 'torch' account. Press return to continue (or ^C to exit) : " >&2

  read var_continue
}


###
### INIT
###

function init () {
  check_if_continue

  show_banner

  confirm

  id | grep torch > /dev/null
  if [ "$?" != 0 ]; then
    echo "Script aborted. Id isn't torch."
    exit 1
  fi
}



#############
### TORCH ###
#############


function install_torch () {
  git clone https://github.com/torch/distro.git ~/torch --recursive

  cd torch

  ./install.sh

  if [ "$?" != 0 ]; then
    echo "Script aborted. install.sh failed."
    exit 1
  fi
}


###################
### ENTRY POINT ###
###################

init

cd ~

install_torch

cd ~

echo ""
echo "#################################################################"
echo "# Script execution has been completed successfully."
echo "# Then, run torch-04_s3.sh as 'torch' account."
echo "#################################################################"
echo ""


exit 0
