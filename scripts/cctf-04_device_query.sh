#!/bin/bash

###################################################################
### ClassCat(R) Deep Learning Service
### Copyright (C) 2016 ClassCat(R) Co.,Ltd. All righs Reserved. ###
###################################################################

# --- Descrption --------------------------------------------------
# 22-mar-16 : rc 0xff.
# 08-mar-16 : beta 3.
# 03-mar-16 : Beta.
#
# --- TODO --------------------------------------------------------
# o PS1 (01-mar-16)
#
# --- HISTORY -----------------------------------------------------
# 29-feb-16 : created.
# -----------------------------------------------------------------


function check_if_continue () {
  local var_continue

  echo -ne "About to query device for ClassCat Deep Learning service. Continue ? (y/n) : " >&2

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
### Device Query
###

function device_query () {
  cp -a /usr/local/cuda/samples ./cuda.samples

  cd ./cuda.samples/1_Utilities/deviceQuery

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

#### Working Dir should be set to /mnt.
mkdir -p /mnt/cuda_test
cd /mnt/cuda_test


### check device query ###

device_query

cd /mnt
rm -rf cuda_test


echo ""
echo "####################################################"
echo "# Script execution has been completed successfully."
echo "# Then, run cctf-05_build_bazel.sh"
echo "####################################################"
echo ""


exit 0


### End of Script ###
