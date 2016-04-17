#!/bin/bash

###################################################################
### ClassCat(R) Deep Learning Service
### Copyright (C) 2016 ClassCat(R) Co.,Ltd. All righs Reserved.
###################################################################

# --- HISTORY -----------------------------------------------------
# 22-mar-16 : rc 0xff.
# 08-mar-16 : beta 3.
# 07-mar-16 : beta 2.
# 03-mar-16 : beta.
# 02-mar-16 : created.
# -----------------------------------------------------------------


. ../conf/postfix.conf


function check_if_continue () {
  local var_continue

  echo -ne "About to install Bro with Postfix for ClassCat Deep Learning service. Continue ? (y/n) : " >&2

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
  echo -e  "\t\t\x1b[22;34m@Install Bro\x1b[m: release: rc 0xff (03/22/2016)"
  # echo -e  ""
}


function confirm () {
  local var_continue

  echo ""
  echo -ne "Make sure to set ../conf/\x1b[22;34mpostfix.conf\x1b[m. Press return to continue (or ^C to exit) : " >&2

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


function install_postfix () {
  apt-get install -y postfix

  sed -i.bak -e "s/^mydestination\s*=.*/mydestination = ${PUBLIC_DNS}, ${PRIVATE_DNS}, localhost.localdomain, localhost/g" /etc/postfix/main.cf

  echo "${PUBLIC_DNS}" > /etc/mailname

  service postfix restart
}


function install_bro () {
  wget https://www.bro.org/downloads/release/bro-2.4.1.tar.gz

  tar xfz bro-2.4.1.tar.gz

  cd bro-2.4.1

  ./configure

  make

  make install

  echo "export PATH=\$PATH:/usr/local/bro/bin" >> /root/.bashrc

  ssh-keygen -t rsa -f ~/.ssh/id_rsa -P ""

  cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

  echo "Host *"                        > ~/.ssh/config
  echo -e "\tStrictHostKeyChecking=no" >> ~/.ssh/config

  sed -i.bak -e "s/MailTo\s*=.*/MailTo=cctf@classcat.com/g" /usr/local/bro/etc/broctl.cfg

  /usr/local/bro/bin/broctl install
  /usr/local/bro/bin/broctl check
  /usr/local/bro/bin/broctl start

}


###################
### ENTRY POINT ###
###################

init


### Postfix ###
install_postfix

### Working Directory ###
mkdir -p /mnt/bro
cd /mnt/bro

### Bro ###
install_bro

### CLEAN UP ###
cd /mnt
rm -rf bro


### Finally ###

echo ""
echo "###################################################################"
echo "# Script execution has been completed successfully."
echo "#"
echo "# You have completed install tasks as root."
echo "###################################################################"
echo ""


exit 0

### End of Script ###
