#!/bin/bash

###################################################################
### ClassCat(R) Deep Learning Service
### Copyright (C) 2016 ClassCat(R) Co.,Ltd. All righs Reserved. ###
###################################################################

# --- HISTORY -----------------------------------------------------
# 08-mar-16 : beta 3.
# 07-mar-16 : beta 2.
# 06-mar-16 : minor bug fix.
# 06-mar-16: sed, use space instead of '/' as delimiter.
# 04-mar-16 : beta.
# 29-feb-16 : created.
# -----------------------------------------------------------------


. ../conf_for_guest/s3_for_guest.conf


function check_if_continue () {
  local var_continue

  echo -ne "About to set s3 for ClassCat Deep Learning service. Continue ? (y/n) : " >&2

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
  echo -e  "\t\t\x1b[22;34m@Set S3\x1b[m: release: beta 3 (03/08/2016)"
  # echo -e  ""
}


function confirm () {
  local var_continue

  echo ""
  echo -ne "This script must be run as 'tensorflow3' account. Press return to continue (or ^C to exit) : " >&2

  read var_continue
}


###
### INIT
###

function init () {
  check_if_continue

  show_banner

  confirm

  id | grep tensorflow3 > /dev/null
  if [ "$?" != 0 ]; then
    echo "Script aborted. Id isn't tensorflow3."
    exit 1
  fi
}


###
### S3CMD
###

function install_and_config_s3cmd () {
  install -o tensorflow3 -g tensorflow3 ../assets/s3cfg.north-east-1 ~/.s3cfg

  sed -i.tmpl -e "s ^access_key\s*=.* access_key=${S3CMD_ACCESS_KEY_FOR_GUEST} g" ~/.s3cfg
  sed -i      -e "s ^secret_key\s*=.* secret_key=${S3CMD_SECRET_KEY_FOR_GUEST} g" ~/.s3cfg
  #sed -i.tmpl -e "s/^access_key\s*=.*/access_key = ${S3CMD_ACCESS_KEY_FOR_GUEST}/g" /root/.s3cfg
  #sed -i      -e "s/^secret_key\s*=.*/secret_key = ${S3CMD_SECRET_KEY_FOR_GUEST}/g" /root/.s3cfg
}



###################
### ENTRY POINT ###
###################

init

install_and_config_s3cmd

echo ""
echo "####################################################"
echo "# Script execution has been completed successfully."
echo "# You have completed tasks for tensorflow3 account."
echo "####################################################"
echo ""


exit 0


### End of Script ###
