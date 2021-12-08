#!/bin/bash
# switch-it - open your application on a specific workspace
#
# Author:  D. Straßel
# License: AGPLv3
#-----------------------------------------------------------------------------------------------------------------------------------


#bash set buildins -----------------------------------------------------------------------------------------------------------------
set -e
set -o pipefail
#-----------------------------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------------------
VERSION="1.0.0"
#-----------------------------------------------------------------------------------------------------------------------------------


# functions ------------------------------------------------------------------------------------------------------------------------

function print_help (){
  echo "switch-it - open your application on a specific workspace

Version: ${VERSION}
Author:  D. Straßel
License: GPLv3

Usage: switch-it -w WORKSPACE_NUMBER -a \"APPLICATION_NAME\"

Arguments:
  -w | --workspace                        the number of the workspace on which the application is to be opened
  -a | --application                      the application that is suppost to be opened
                                          (\"...\" have to be set if you hand over flags to your application)

  -h or --help                            print this help and exit
  --version                               print the CARME version and exit
"
  exit 0
}


function die () {
# function that is called if a command fails

  echo "ERROR: ${1}"
  exit 200

}


function check_command () {
# function that checks if a command is available or not on your path

  if ! command -v "${1}" >/dev/null 2>&1 ;then
    die "command '${1}' not found"
  fi

}


function print_version () {
# print the current version

  echo "Version: ${VERSION}"
  exit 0

}

function switch_command () {
  local WORKSPACE="${1}"
  local PROGRAM

  read -r -a PROGRAM <<< "${2}"

  wmctrl -s "${WORKSPACE}"
  "${PROGRAM[@]}" &
  sleep 0.1
  wmctrl -r :ACTIVE: -t "${WORKSPACE}"
}

#-----------------------------------------------------------------------------------------------------------------------------------


# main -----------------------------------------------------------------------------------------------------------------------------
if [[ ${#} -eq 0 ]];then

  print_help

else

  while [[ ${#} -gt 0 ]];do
    KEY="${1}"
    case ${KEY} in
     -h|--help)
       print_help
       shift
       shift
     ;;
     --version)    
       print_version
       shift       
       shift
     ;;
     -w|--workspace)
       HELPER="${2}"
       WORKSPACE=$((--HELPER))
       shift
       shift
     ;;
     -a|--application)
       shift
       PROGRAM="${1}"
       shift
     ;;
     *)
      print_help
      shift
     ;;
   esac
  done

fi

#check if a workspace was no defined and if true open on workspace 1
[[ -z "${WORKSPACE}" ]] && WORKSPACE="0"


# check if the command you want to execute is available on ${PATH}
SPACE=" "
PROGRAM_HELPER=${PROGRAM%%"${SPACE}"*}
check_command "${PROGRAM_HELPER}"


# open the command on the desired workspace
switch_command "${WORKSPACE}" "${PROGRAM}"

#-----------------------------------------------------------------------------------------------------------------------------------

exit 0
