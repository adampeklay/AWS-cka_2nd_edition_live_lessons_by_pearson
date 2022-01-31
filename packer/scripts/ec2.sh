#!/bin/bash

#############################################################################################
#    This script finishes configuring the ec2 instances per the instructors requirements    #
#                                       -----------                                         #
#  Packer sets an `at`` job to run this script when an ec2 instnce is created from the ami  #
#                                       -----------                                         #
#############################################################################################

set -x

# Variables

LOCAL_IP="$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)"
CONTROLLER_IP="192.168.104.110"
WORKER_1_IP="192.168.4.111"
WORKER_2_IP="192.168.4.112"
WORKER_3_IP="192.168.4.113"
DIRNAME="$0"

# Functions

append_hosts_file () {
  declare -A ENTRIES=( [controller]=${CONTROLLER_IP} [worker-1]=${WORKER_1_IP} [worker-2]=${WORKER_2_IP} [worker-3]=${WORKER_3_IP} )
  for entries in ${!ENTRIES[@]}; do
    echo "$entries   ${ENTRIES[$entries]}" | sudo tee -a /etc/hosts; 
  done
}

#####################
# Update /etc/hosts #
#####################

append_hosts_file

if [ $? -eq 0 ]; then
  echo "/etc/hosts updated successfully"
else
  echo "investigate, error running append_hosts_file function"
  exit 1
fi

######################################
# Set hostnames on cluster instances #
######################################

if [[ $LOCAL_IP == $CONTROLLER_IP ]]; then
  sudo hostnamectl set-hostname controller
  echo "controller hostname set successfully"
elif [[ $LOCAL_IP == $WORKER_1_IP ]]; then
  sudo hostnamectl set-hostname worker-1
  echo "worker hostname set successfully"
elif [[ $LOCAL_IP == $WORKER_2_IP ]]; then
  sudo hostnamectl set-hostname worker-2
  echo "worker hostname set successfully"
elif [[ $LOCAL_IP == $WORKER_3_IP ]]; then
  sudo hostnamectl set-hostname worker-3
  echo "worker hostname set successfully"
else
  echo "investigate, error updating hostname(s)"
  exit 1
fi

echo "script completed succesfully, self destructing in 1 minute"

echo "sudo rm -f $HOME/$DIRNAME" | at now +1 minute

if [ $? -eq 0]; then
  echo "self destruction successfully scheduled for 1 minute from now, goodbye"
else
  echo "investigate, error scheduling self deletion"
  exit 1
fi

exit 0
