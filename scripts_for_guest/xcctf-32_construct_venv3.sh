#!/bin/bash

###################################################################
### ClassCat(R) Deep Learning Service
### Copyright (C) 2016 ClassCat(R) Co.,Ltd. All righs Reserved. ###
###################################################################

# --- Descrption --------------------------------------------------
# o Run as the guest account: tensorflow.
#
# --- TODO --------------------------------------------------------
# o PS1 (01-mar-16)
#
# --- HISTORY -----------------------------------------------------
# 08-mar-16 : beta 3.
# 07-mar-16 : beta 2.
# 06-mar-16 : modify pip install pkgs.
# 04-mar-16 : beta.
# 29-feb-16 : created.
# -----------------------------------------------------------------


function check_if_continue () {
  local var_continue

  echo -ne "About to construct virtualenv3 for ClassCat Deep Learning service. Continue ? (y/n) : " >&2

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
  echo -e  "\t\t\x1b[22;34m@Construct VirutualEnv 3\x1b[m: release: beta 3 (03/07/2016)"
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
### Construct VirtualEnv
###

function create_venv_container () {
  virtualenv --python /usr/bin/python3 venv3_tf071

  echo "" >> ~/.bashrc
  echo ". venv3_tf071/bin/activate" >> ~/.bashrc
}


function pip_install_pkgs () {
  . venv3_tf071/bin/activate

  pip install wheel
  if [ "$?" != 0 ]; then
    echo "Script aborted. pip install wheel failed."
    exit 1
  fi

  pip install numpy
  if [ "$?" != 0 ]; then
    echo "Script aborted. pip install numpy failed."
    exit 1
  fi

  pip install scipy
  if [ "$?" != 0 ]; then
    echo "Script aborted. pip install scipy failed."
    exit 1
  fi

  pip install pandas
  if [ "$?" != 0 ]; then
    echo "Script aborted. pip install pandas failed."
    exit 1
  fi

  pip install jupyter
  if [ "$?" != 0 ]; then
    echo "Script aborted. pip install jupyter failed."
    exit 1
  fi

  pip install ipython
  if [ "$?" != 0 ]; then
    echo "Script aborted. pip install ipython failed."
    exit 1
  fi

  pip install matplotlib
  if [ "$?" != 0 ]; then
    echo "Script aborted. pip install matplotlib failed."
    exit 1
  fi
}



###################
### ENTRY POINT ###
###################

init

cd ~

create_venv_container

pip_install_pkgs

cd ~


echo ""
echo "#############################################################################"
echo "# Script Execution has been completed successfully."
echo "# 1) Be sure to 'Re-login' to this account to activate a container."
echo "#" 
echo "# 2) Then, run cctf-33_install_tf071_into_venv3.sh as 'tensorflow3' account."
echo "#############################################################################"
echo ""


exit 0


### End of Script ###
