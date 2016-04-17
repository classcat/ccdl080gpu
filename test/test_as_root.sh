#!/bin/bash

###################################################################
### Copyright (C) 2016 ClassCat(R) Co.,Ltd. All righs Reserved. ###
###################################################################

# --- HISTORY -----------------------------------------------------
# 29-feb-16 : created.
# -----------------------------------------------------------------

lspci

lsmod | grep -y nvidia

nvidia-smi

cd /mnt

cp -a /usr/local/cuda/samples ./cuda.samples

cd cuda.samples/1_Utilities/deviceQuery

make

./deviceQuery

make clean

bazel version
