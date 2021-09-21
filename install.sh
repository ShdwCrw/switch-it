#!/bin/bash
# script to install switch-it
#
# Author:  D. Straßel
# License: GPLv3
#-----------------------------------------------------------------------------------------------------------------------------------


#bash set buildins -----------------------------------------------------------------------------------------------------------------
set -e
set -o pipefail
#-----------------------------------------------------------------------------------------------------------------------------------


# define functions -----------------------------------------------------------------------------------------------------------------

function die () {
# function that is called if a command fails

  echo "ERROR: ${1}"
  exit 200

}


function is_bash () {
# check if bash is used to execute the script
# USAGE: is_bash

  if [[ ! "${BASH_VERSION}" ]]; then
    echo "ERROR: This is a bash-script. Please use bash to execute it!"
    exit 200
  fi

}


function is_root () {
# check if root executes this script
# USAGE: is_root

  if [[ ! "$(whoami)" = "root" ]]; then
    echo "ERROR: you need root privileges to run this script"
    exit 200
  fi

}
#-----------------------------------------------------------------------------------------------------------------------------------


# main -----------------------------------------------------------------------------------------------------------------------------

# check if bash is used to execute the script
is_bash


# check if root executes this script
is_root


# go to /opt
cd /opt || die "cannot open '/opt'"


# clone latest version
git clone https://github.com/ShdwCrw/switch-it.git


# create symlink
ln -s /opt/switch-it/switch-it.sh /usr/local/bin/switch-it
