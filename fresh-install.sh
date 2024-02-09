#!/bin/bash

sudo add-apt-repository ppa:apt-fast/stable

sudo apt-get update


# Add Docker's official GPG key:
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null


sudo apt-get update

sudo apt-get -y install apt-fast heif-gdk-pixbuf powertop 

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo usermod -aG docker $USER

newgrp docker

sudo systemctl enable docker.service

sudo systemctl enable containerd.service

echo 'Acquire::Languages { "none"; };' | sudo tee /etc/apt/apt.conf

echo "Apt-fast, Powertop, HEIC & Language file are all setup!"

