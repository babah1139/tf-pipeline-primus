#!/bin/bash
sudo yum update -y 
sudo yum install -y
sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo usermod -aG docker ec2-user
docker run -p 8080:80 nginx