#!/bin/bash

###################################################################
### ClassCat(R) Deep Learning Service
### Copyright (C) 2016 ClassCat(R) Co.,Ltd. All righs Reserved. ###
###################################################################

# --- Descrption --------------------------------------------------
# o Run as the guest account: torch.
#
# --- HISTORY -----------------------------------------------------
# 22-mar-16 : rc 0xff.
# 08-mar-16 : beta 3.
# 07-mar-16 : beta 2.
# 04-mar-16 : beta.
# -----------------------------------------------------------------


function check_if_continue () {
  local var_continue

  echo -ne "About to run query device for ClassCat Deep Learning service. Continue ? (y/n) : " >&2

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



###
### Device Query
###

function device_query () {
  cp -a /usr/local/cuda/samples ~/cuda.samples

  cd ~/cuda.samples/1_Utilities/deviceQuery

  make

  ./deviceQuery

  if [ "$?" != 0 ]; then
    echo "Script aborted. ./deviceQuery failed."
    exit 1
  fi

  make clean
}



###################
### ENTRY POINT ###
###################

init

cd ~

### check device query ###

device_query

cd ~

echo ""
echo "#################################################################"
echo "# Script execution has been completed successfully."
echo "# Then, run torch-02_construct_venv2.sh as 'torch' account."
echo "#################################################################"
echo ""


exit 0


### End of Script ###
