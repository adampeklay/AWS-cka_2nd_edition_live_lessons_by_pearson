#!/bin/bash

##################################################################################################
#       This script uses the instructors scripts to create an AMI that terraform will call       #
#                                       -----------                                              #
#  I've added a few things myself, like the ssh keypair and the at job, which finishes the ec2s  #
##################################################################################################

set -x

# Variables

REPO_DIR="github_lab_repo"
CLUSTER_KEY="cluster_key_rsa"
REPO="https://github.com/sandervanvugt/cka.git"
CONTAINER_LAB_SCRIPT="setup-container.sh"
K8S_LAB_SCRIPT="setup-kubetools.sh"
SCRIPT="$0"

# Arrays

packages=("vim" "git" "bash-completion" "at")

############################
# Install required packges #
############################

logger ": $SCRIPT : installing: ${packages[@]}"

sudo yum install "${packages[@]}" -y

if [ $? -eq 0 ]; then
  logger ": $SCRIPT : packages installed successfully"
else
  logger ": $SCRIPT : investigate, error installing required packages"
  exit 1
fi

##################################
# Enable and start the at deamon #
##################################

logger ": $SCRIPT : enabling and starting atd"

sudo systemctl enable --now atd

if [ $? -eq 0 ]; then
  logger ": $SCRIPT : atd enabled and started succesfully"
else
  logger ": $SCRIPT : investigate, error enabling and starting atd"
  exit 1
fi

##############################
# Clone the instructors repo #
##############################

logger ": $SCRIPT : cloning the required git rep: $REPO"

git clone $REPO $REPO_DIR

if [ $? -eq 0 ]; then
  logger ": $SCRIPT : git repo cloned successfully"
else
  logger ": $SCRIPT : investigate, error cloning github repo"
  exit 1
fi

###############################
# Run the instructors scripts #
###############################

logger ": $SCRIPT : running instructor provided lab setup scripts"

sudo bash ${REPO_DIR}/${CONTAINER_LAB_SCRIPT} && \
sudo bash ${REPO_DIR}/${K8S_LAB_SCRIPT}

if [ $? -eq 0 ]; then
  logger ": $SCRIPT : lab scripts completed succesfully"
else
  logger ": $SCRIPT : investigate, error running instructor provided lab scripts"
  exit 1
fi

##########################################
# Cleanup - remove github repo directory #
##########################################

logger ": $SCRIPT : deleting ${HOME}/${REPO_DIR}"

sudo rm -rf ${HOME}/${REPO_DIR}

if [ $? -eq 0 ]; then
  logger ": $SCRIPT : ${HOME}/${REPO_DIR} deletion success"
else
  logger ": $SCRIPT : ${HOME}/${REPO_DIR} deletion failure"
  exit 1
fi

##############################
# Create cluster ssh keypair #
##############################

ssh-keygen -t rsa -b 2048 -N '' -f ${HOME}/.ssh/${CLUSTER_KEY}

if [ $? -eq 0 ]; then
  logger ": $SCRIPT : $CLUSTER_KEY keypair created in ${HOME}/.ssh/ successfully"
else
  logger ": $SCRIPT : investigate, error creating ssh keypair"
  exit 1
fi

#######################################################
# Set the at job to run the script 2 minutes from now #
#######################################################

sudo at now +2 minute -f $HOME/ec2.sh

if [ $? -eq 0 ]; then
   logger ": $SCRIPT : at job scheduled successfully, hostnames will be set upon ec2 creation"
else
   logger ": $SCRIPT : investigate, error setting at job"
   exit 1
fi

logger ": $SCRIPT : finished script ${HOME}/${SCRIPT}"

exit 0
