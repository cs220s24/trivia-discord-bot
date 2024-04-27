#!/bin/bash

# Install Docker
echo "Installing Docker..."
sudo yum install -y docker

# Start Docker service
echo "Starting Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

# Add "ec2-user" to the docker group
echo "Adding \"ec2-user\" to the docker group..."
sudo usermod -a -G docker ec2-user

# Inform user to log out and log back in to apply changes
echo ""
echo "*********************************************************************"
echo "To apply changes, you must log out and reconnect to the EC2 instance."
echo "Once you do, go back into the repository and run:"
echo ""
echo "sh build.sh"
echo ""
echo "*********************************************************************"
