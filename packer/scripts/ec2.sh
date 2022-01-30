#!/bin/bash

##########################################################################################
#  This script finishes configuring the ec2 instances per the instructors requirements   #
#                                       -----------                                      #
# - Packer sets an at job to run this script when an ec2 instnce is created from the ami #
# - You can run the script again if need be                                              #
# - If the script had errors, a file will be written in your home directory              #
#   - - See `else` --> `echo` below for details                                          #
#                                       -----------                                      #
##########################################################################################

set -x

# Variables

LOCAL_IP="$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)"
CONTROLLER_IP="192.168.104.110"
WORKER_1_IP="192.168.4.111"
WORKER_2_IP="192.168.4.112"
WORKER_3_IP="192.168.4.113"

# Functions

append_hosts_file () {
  # Declare associate array
  declare -A ENTRIES=( [controller]=$CONTROLLER_IP [worker-1]=$WORKER_1_IP [worker-2]=$WORKER_2_IP [worker-3]=$WORKER_3_IP )
  # backup original /etc/hosts file to $original_hosts, in case script needs to be ran ad hoc
  orginal_hosts="~/hosts_orig"
  staged_hosts="~/hosts
  # Set /etc/hosts
  if [ -n $original_hosts ]; then
    $(touch $staged_hosts && > $staged_hosts)
  else
    $(sudo cp /etc/hosts $original_hosts)
    $(sudo cp /etc/hosts $original_hosts)
  fi
  # call arrary to update file
  for entries in ${!ENTRIES[@]}; do
    $(sudo echo "$entries   ${ENTRIES[$entries]}" >> $staged_hosts); 
  done
  # hard update /etc/hosts
  $(sudo mv $staged_hosts /etc/hosts)
}

#############################################################
# Update /etc/hosts, and set hostnames on cluster instances #
#############################################################

if [[ $(append_hosts_file) ]]; then
  echo "/etc/hosts updated"
else
  echo "investigate, error updating /etc/hosts" > "$HOME/script_error.txt"
fi

if [[ $LOCAL_IP == $CONTROLLER_IP ]];then
  sudo hostnamectl set-hostname "controller"
elif [[ $LOCAL_IP == $WORKER_1_IP ]];then
  sudo hostnamectl set-hostname "worker-1"
elif [[ $LOCAL_IP == $WORKER_2_IP ]];then
  sudo hostnamectl set-hostname "worker-2"
elif [[ $LOCAL_IP == $WORKER_3_IP ]];then  
  sudo hostnamectl set-hostname "worker-3" 
else
  echo "investigate, error updating hostnames" > "$HOME/script_error.txt"
fi
