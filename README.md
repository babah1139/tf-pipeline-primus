# Terraform-reusable-project

This project describes how to provision infrastructure in AWS using terraform.

This template can be use to spin up the same infrastructure in multiple environments i.e prod, pre-prod, dev etc

All you need to do is create your own varriable files and define your values and everything works like magic.

NOTE: this simple architecture launches and infrastructure with the following resources
1. custom vpc
2. one subnet
3. internet gateway 
4. route table associating with the subnet
5. security group with port 22 for ssh and port 8080 for nginx server
6. keypair with custom private key in your local computer and public key passed to the server 
7. one ec2 instance with docker and nginx configuration passed as user data using the script-file 

As time goes on, other features will be added to make the infrastucture highly available, more secured and resilence. stay tune.