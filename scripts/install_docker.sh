#!/bin/bash

set -e
set -x

# https://docs.docker.com/install/linux/docker-ce/ubuntu/

# remove old versions
sudo apt-get remove -y docker docker-engine docker.io || true

# set up the repository
sudo apt-get update -y
sudo apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"

# install Docker CE
sudo apt-get update -y
sudo apt-get install -y docker-ce
