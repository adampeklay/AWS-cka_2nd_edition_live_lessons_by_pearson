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

logger "installing: ${packages[@]}"

sudo yum install "${packages[@]}" -y

if [ $? -eq 0 ]; then
  logger "packages installed successfully"
else
  logger "investigate, error installing required packages"
  exit 1
fi

##################################
# Enable and start the at deamon #
##################################

logger "enabling and starting atd"

sudo systemctl enable --now atd

if [ $? -eq 0 ]; then
  logger "atd enabled and started successfully"
else
  logger "investigate, error enabling and starting atd"
  exit 1
fi

##############################
# Clone the instructors repo #
##############################

logger "cloning the required git rep: $REPO"

git clone $REPO $REPO_DIR

if [ $? -eq 0 ]; then
  logger "git repo cloned successfully"
else
  logger "investigate, error cloning github repo"
  exit 1
fi

###############################
# Run the instructors scripts #
###############################

logger "running instructor provided lab setup scripts"

sudo bash ${REPO_DIR}/${CONTAINER_LAB_SCRIPT} && \
sudo bash ${REPO_DIR}/${K8S_LAB_SCRIPT}

if [ $? -eq 0 ]; then
  logger "lab scripts completed successfully"
else
  logger "investigate, error running instructor provided lab scripts"
  exit 1
fi

##########################################
# Cleanup - remove github repo directory #
##########################################

logger "deleting ${HOME}/${REPO_DIR}"

sudo rm -rf ${HOME}/${REPO_DIR}

if [ $? -eq 0 ]; then
  logger "${HOME}/${REPO_DIR} deletion success"
else
  logger "${HOME}/${REPO_DIR} deletion failure"
  exit 1
fi

##############################
# Create cluster ssh keypair #
##############################

ssh-keygen -t rsa -b 2048 -N '' -f ${HOME}/.ssh/${CLUSTER_KEY}

if [ $? -eq 0 ]; then
  logger "$CLUSTER_KEY keypair created in ${HOME}/.ssh/ successfully"
else
  logger "investigate, error creating ssh keypair"
  exit 1
fi

#####################################
# create and update authorized_keys #
#####################################

cat ${HOME}/.ssh/${CLUSTER_KEY}.pub >> ${HOME}/.ssh/authorized_keys

if [ $? -eq 0 ]; then
  logger "${HOME}/.ssh/authorized_keys created and updated successfully"
else
  logger "investigate, error creating and updating ${HOME}/.ssh/authorized_keys"
  exit 1
fi

#################################
# create and udpate .ssh/config #
#################################

cat << EOF > ${HOME}/.ssh/config
Host controller
  Hostname controller
  User centos
  IdentityFile ~/.ssh/cluster_key_rsa
Host worker-1
  HostName worker-1
Host worker-2
  HostName worker-2
Host worker-3
  HostName worker-3
Host worker-*
  Hostname worker-*
  User centos
  IdentityFile ~/.ssh/cluster_key_rsa
EOF

if [ $? -eq 0 ]; then
   logger "${HOME}/.ssh/config created and updated successfully"
else
   logger "investigate, error creating and updating ${HOME}/.ssh/config"
   exit 1
fi

chmod 600  ${HOME}/.ssh/config

if [ $? -eq 0 ]; then
   logger "${HOME}/.ssh/config permissions updated successfully"
else
   logger "investigate, error updating ${HOME}/.ssh/config permissions"
   exit 1
fi

if [ $? -eq 0 ]; then
   logger "at job scheduled successfully, hostnames will be set upon ec2 creation"
else
   logger "investigate, error setting at job"
   exit 1
fi

#######################################################
# Set the at job to run the script 2 minutes from now #
#######################################################

sudo at now +2 minute -f $HOME/ec2.sh

if [ $? -eq 0 ]; then
   logger "at job scheduled successfully, hostnames will be set upon ec2 creation"
else
   logger "investigate, error setting at job"
   exit 1
fi

logger "all tasks completed successfully"

exit 0
