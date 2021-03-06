#!/bin/bash

###################################################################
### ClassCat(R) Deep Learning Service
### Copyright (C) 2016 ClassCat(R) Co.,Ltd. All righs Reserved. ###
###################################################################

# --- Descrption --------------------------------------------------
# Run on the account - tensorflow070.
#
# --- HISTORY -----------------------------------------------------
# 10-may-16 : beta.
# 18-apr-16 : alpha.
#
# --- 0.7.1 -------------------------------------------------------
# 22-mar-16 : rc 0xff.
# 08-mar-16 : beta 3.
# 07-mar-16 : beta 2.
# 04-mar-16 : beta.
# 29-feb-16 : created.
# -----------------------------------------------------------------

#
# $ TF_UNOFFICIAL_SETTING=1 ./configure
#
# Please specify the location of python. [Default is /mnt/tensorflow.xxx/venv2_tf_build/bin/python]: 
# Do you wish to build TensorFlow with GPU support? [y/N] y
# GPU support will be enabled for TensorFlow
# Please specify the Cuda SDK version you want to use, e.g. 7.0. [Leave empty to use system default]: 7.5
# Please specify the location where CUDA 7.5 toolkit is installed. Refer to README.md for more details. [Default is /usr/local/cuda]: 
# Please specify the Cudnn version you want to use. [Leave empty to use system default]: 4.0.7
# Please specify the location where cuDNN 4.0.7 library is installed. \
#     Refer to README.md for more details. [Default is /usr/local/cuda]: /usr/local/cudnn-r4/cuda
# Please specify a list of comma-separated Cuda compute capabilities you want to build with. \
#     You can find the compute capability of your device at: https://developer.nvidia.com/cuda-gpus. \
#     Please note that each additional compute capability significantly increases your build time and binary size. \
# [Default is: "3.5,5.2"]: 3.0
#

function check_if_continue () {
  local var_continue

  echo -ne "About to install tensorflow for ClassCat Deep Learning service. Continue ? (y/n) : " >&2

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
  echo -e  "\t\t\x1b[22;34m@Insall TensorFlow\x1b[m: release: beta (05/10/2016)"
  # echo -e  ""
}


function confirm () {
  local var_continue

  echo ""
  echo -ne "This script must be run as 'tensorflow' account. Press return to continue (or ^C to exit) : " >&2

  read var_continue
}



###
### INIT
###

function init () {
  check_if_continue

  show_banner

  confirm

  id | grep tensorflow > /dev/null
  if [ "$?" != 0 ]; then
    echo "Script aborted. Id isn't tensorflow2."
    exit 1
  fi
}



###
### TensorFlow 0.7.1
###

function clone_and_config_tensorflow080 () {
  git clone --recurse-submodules https://github.com/tensorflow/tensorflow tensorflow.080

  ln -s tensorflow.080 tensorflow

  cd tensorflow

  git checkout "v0.8.0"
  #git checkout "v0.8.0rc0"
  #git checkout "v0.7.1"

  TF_UNOFFICIAL_SETTING=1 ./configure

  if [ "$?" != 0 ]; then
    echo "Script aborted. ./configure failed."
    exit 1
  fi
}



###
### Build Examples
###

function start_build () {
  local var_continue

  echo ""
  echo -ne "Start building examples and run it. Press return to continue : " >&2

  read var_continue
}


function build_example () {
  start_build

  cd ~/tensorflow

  bazel build -c opt --config=cuda //tensorflow/cc:tutorials_example_trainer
  if [ "$?" != 0 ]; then
    echo "Script aborted. bazel build cc:tutorials_example_trainer failed."
    exit 1
  fi

  bazel-bin/tensorflow/cc/tutorials_example_trainer --use_gpu
  if [ "$?" != 0 ]; then
    echo "Script aborted. run cc/tutorials_example_trainer failed."
    exit 1
  fi
}



###
### Build Pip Package
###

function start_build2 () {
  local var_continue

  echo ""
  echo -ne "Start building Pip package and store it. Press return to continue : " >&2

  read var_continue
}


function build_pip_package () {
  start_build2

  cd ~/tensorflow

  bazel build -c opt --config=cuda //tensorflow/tools/pip_package:build_pip_package
  if [ "$?" != 0 ]; then
    echo "Script aborted. bazel build pip_package:build_pip_package failed."
    exit 1
  fi

  bazel-bin/tensorflow/tools/pip_package/build_pip_package ~/.tf_pip_pkg
  if [ "$?" != 0 ]; then
    echo "Script aborted. bazel-bin/tensorflow/tools/pip_package/build_pip_package ~/.tf_pip_pkg failed."
    exit 1
  fi
}



###
### Install TensorFlow Pip Package
###

function install_tensorflow () {
  pip install ~/.tf_pip_pkg/tensorflow-0.8.0-py2-none-any.whl
  #pip install ~/.tf_pip_pkg/tensorflow-0.8.0rc0-py2-none-any.whl
  #pip install ~/.tf_pip_pkg/tensorflow-0.7.1-py2-none-any.whl
  if [ "$?" != 0 ]; then
    echo "Script aborted. pip install tensorflow-0.8.0-py2-none-any.whl failed."
    exit 1
  fi
}



###################
### ENTRY POINT ###
###################

init

cd ~

clone_and_config_tensorflow080

cd ~

build_example

cd ~

build_pip_package

cd ~

install_tensorflow


# Backup it further.
cp -a  ~/.tf_pip_pkg /var/tmp/tf_pip_pkg.080.bak


echo ""
echo "####################################################"
echo "# Script execution has been completed successfully."
echo "# Then, run tf-04_s3.sh as 'tensorflow' account."
echo "####################################################"
echo ""


exit 0
