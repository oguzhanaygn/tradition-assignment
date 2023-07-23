#!/bin/bash

sudo yum update -y
sudo yum install -y httpd.x86_64
sudo systemctl start httpd.service
sudo systemctl enable httpd.service
echo “Welcome to $(hostname -f)” > /var/www/html/index.html
sudo yum install -y mod_ssl
sudo systemctl restart httpd
