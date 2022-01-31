#!/bin/bash

##################################################################################################
#       This script uses the instructors scripts to create an AMI that terraform will call       #
#  I've added a few things myself, like the ssh keypair and the at job, which finishes the ec2s  #
#                                       -----------                                              #
# Tasks:                                                                                         #
# ------                                                                                         #
# - Install required packages                                                                    #
# - Enable and start atd                                                                         #
# - Clone the instructors repo                                                                   #
# - Run the instructors sripts                                                                   #
# - Remove the cloned repos directory                                                            #
# - Create an ssh keypair for the cluster                                                        #
# - Set an `at` job that will trigger a script (ec2.sh)                                          #
# - - ec2.sh will run when the instaces boot after being created via terraform                   #
# - - - ec2.sh will set hostnames and and update /etc/hosts on cluster instances                 #
#                                       -----------                                              #
##################################################################################################

set -x

# Variables

REPO_DIR="github_lab_repo"
CLUSTER_KEY="cluster_key_rsa"
REPO="https://github.com/sandervanvugt/cka.git"
CONTAINER_LAB_SCRIPT="setup-container.sh"
K8S_LAB_SCRIPT="setup-kubetools.sh"

# Functions

install_packages () {
  packages=("vim" "git" "bash-completion" "at")
  sudo yum install "${packages[@]}" -y;
}

#############
# Run tasks #
#############

# Install required packges

echo "installing: "${packages[@]}""

install_packages

if [ $? -eq 0 ]; then
  echo "packages installed successfully"
else
  echo "investigate, error installing required packages"
  exit 1
fi

# Enable and start the at deamon

echo "enabling and starting atd"

sudo systemctl enable --now atd

if [ $? -eq 0 ]; then
  echo "atd enabled and started succesfully"
else
  echo "investigate, error enabling and starting atd"
  exit 1
fi

# Clone the instructors repo

echo "cloning the required git rep: $REPO"

git clone $REPO $REPO_DIR

if [ $? -eq 0 ]; then
  echo "git repo cloned successfully"
else
  echo "investigate, error cloning github repo"
  exit 1
fi

# Run the instructors scripts

echo "running instructor provided lab setup scripts"

sudo bash ${REPO_DIR}/${CONTAINER_LAB_SCRIPT} && \
sudo bash ${REPO_DIR}/${K8S_LAB_SCRIPT}

if [ $? -eq 0 ]; then
  echo "lab scripts completed succesfully"
else
  echo "investigate, error running instructor provided lab scripts"
  exit 1
fi

# Clean up after ourselves

echo "housekeeping: deleting $HOME/${REPO_DIR}"

sudo rm -rf $HOME/${REPO_DIR}

if [ $? -eq 0 ]; then
  echo "cleanup success"
else
  echo "cleanup failure"
  exit 1
fi

# Create cluster ssh keypair

ssh-keygen -t rsa -b 2048 -N '' -f $HOME/.ssh/${CLUSTER_KEY}

if [ $? -eq 0 ]; then
  echo "$CLUSTER_KEY keypair created in $HOME/.ssh/ successfully"
else
  echo "investigate, error creating ssh keypair"
  exit 1
fi

# Set the at job to run the script 2 minutes from now

sudo at now +2 minute -f $HOME/ec2.sh

if [ $? -eq 0 ]; then
   echo "at job scheduled successfully, hostnames will be set upon ec2 creation"
else
   echo "investigate, error setting at job"
   exit 1
fi
