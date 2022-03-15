#!/bin/bash

sudo apt-get update -y && sudo apt-get upgrade -y

curl -sSL https://get.docker.com | sh
sudo usermod -aG docker ${USER}

sudo apt-get install libffi-dev libssl-dev -y
sudo apt install python3-dev -y
sudo apt-get install -y python3 python3-pip -y
sudo pip3 install docker-compose

sudo systemctl enable docker
sudo chmod 666 /var/run/docker.sock