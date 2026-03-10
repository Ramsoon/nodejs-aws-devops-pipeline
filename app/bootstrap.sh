#!/bin/bash

set -e

echo "Updating system..."
sudo apt update -y

echo "Installing Docker..."
sudo apt install -y docker.io

echo "Starting Docker..."
sudo systemctl start docker
sudo systemctl enable docker

echo "Adding ubuntu user to docker group..."
sudo usermod -aG docker ubuntu

echo "Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "Creating app directory..."
mkdir -p /home/ubuntu/app

echo "Bootstrap completed"
