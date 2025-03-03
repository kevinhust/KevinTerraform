#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h1>Welcome to ACS730 Project 1! My private IP is $myip Built by Kevin’s Terraform!</h1><br>" > /var/www/html/index.html
sudo systemctl start httpd
sudo systemctl enable httpd