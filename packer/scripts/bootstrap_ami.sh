#!/bin/bash

echo "installing vim, git & bash-completion ..."
sudo yum install vim git bash-completion -y

echo "cloning the required git repo ..."
git clone https://github.com/sandervanvugt/cka.git github_repo && cd github_repo

echo "running required scripts"
sudo bash setup-container.sh && sudo bash setup-kubetools.sh