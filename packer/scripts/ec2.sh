#!/bin/bash

##########################################################################################
#  This script finishes configuring the ec2 instances per the instructors requirements   #
#                                       -----------                                      #
# - Packer sets an at job to run this script when an ec2 instnce is created from the ami #
# - You can run the script again if need be                                              #
# - If the script had errors, they will be writtin in your home directory                #
#   - - See the `else` blocks `echo` string below for details                             #
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
  # Set /etc/hosts.  Can't sudo append text to /etc/hosts - workaround seen below
  $(sudo cat /etc/hosts >> ~/hosts)
  for entries in ${!ENTRIES[@]}; do 
    $(sudo echo "$entries   ${ENTRIES[$entries]}" >> ~/hosts); 
  done
  $(sudo mv ~/hosts /etc/hosts)
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