#!/bin/bash

#############################################################################################
#    This script finishes configuring the ec2 instances per the instructors requirements    #
#                                       -----------                                         #
#  Packer sets an `at`` job to run this script when an ec2 instnce is created from the ami  #
#############################################################################################

# Variables

LOCAL_IP="$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)"
CONTROLLER_IP="192.168.104.110"
WORKER_1_IP="192.168.4.111"
WORKER_2_IP="192.168.4.112"
WORKER_3_IP="192.168.4.113"
SCRIPT="$0"

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

logger ": ${SCRIPT} : appending cluster hosts and private ips to /etc/hosts"

append_hosts_file
if [ $? -eq 0 ]; then
  logger ": ${SCRIPT} : /etc/hosts updated successfully"
else
  logger ": ${SCRIPT} : investigate, error running append_hosts_file function"
  exit 1
fi

######################################
# Set hostnames on cluster instances #
######################################

logger ": ${SCRIPT} : setting cluster hostnames"

if [[ $LOCAL_IP == $CONTROLLER_IP ]]; then
  sudo hostnamectl set-hostname controller
  if [ $? -eq 0 ]; then
    logger ": ${SCRIPT} : controller hostname set successfully"
  else
    logger ": ${SCRIPT} : investigate, error setting controller hostname"
    exit 1
  fi
elif [[ $LOCAL_IP == $WORKER_1_IP ]]; then
  sudo hostnamectl set-hostname worker-1
  if [ $? -eq 0 ]; then
    logger ": ${SCRIPT} : worker-1 hostname set successfully"
  else
    logger ": ${SCRIPT} : investigate, error setting worker-1 hostname"
    exit 1
  fi
elif [[ $LOCAL_IP == $WORKER_2_IP ]]; then
  sudo hostnamectl set-hostname worker-2
  if [ $? -eq 0 ]; then
    logger ": ${SCRIPT} : worker-2 hostname set successfully"
  else
    logger ": ${SCRIPT} : investigate, error setting worker-2 hostname"
    exit 1
  fi
elif [[ $LOCAL_IP == $WORKER_3_IP ]]; then
  sudo hostnamectl set-hostname worker-3
  if [ $? -eq 0 ]; then
    logger ": ${SCRIPT} : worker-3 hostname set successfully"
  else
    logger ": ${SCRIPT} : investigate, error setting worker-3 hostname"
    exit 1
  fi
else
  logger ": ${SCRIPT} : investigate error(s), instance private IP(s) aren't matching"
  exit 1
fi

########################################
# Delete this script 1 minute from now #
########################################

logger ": ${SCRIPT} : setting at job to delete myself (file: ${HOME}/${SCRIPT})"

echo "rm -f ${HOME}/${SCRIPT}" | at now +1 minute
if [ $? -eq 0 ]; then
  logger ": ${SCRIPT} : job scheduled succesfully"
else
  logger ": ${SCRIPT} : investigate, error scheduling self deletion"
  exit 1
fi

logger ": ${SCRIPT} : finished script ${HOME}/${SCRIPT}"

exit 0
