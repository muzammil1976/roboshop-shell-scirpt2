#!/bin/bash

USER_ID=$(id -u)
if [ $USER_ID -ne 0 ]; then
    echo You are non root user
    echo you can run this script as root user or with sudo
    exit 1
fi
yum install nginx -y
systemctl enable nginx
systemctl start nginx
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
cd/usr/share/nginx/html
rm -rf *
unzip /tmp/frontend.zip
mv frontend-main/*
mv static/* .
rm -rf frontend-main README.dm
mv localhost.conf /etc/nginx/default.d/roboshop.conf
