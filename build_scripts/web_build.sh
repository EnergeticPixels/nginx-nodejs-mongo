#!/usr/bin/env bash

sudo apt-get update
sudo apt-get install -y nginx python3-acme python3-certbot python3-mock python3-openssl python3-pkg-resources python3-pyparsing python3-zope.interface
sudo apt-get install -y python3-certbot-nginx

# Start and enable web server
sudo systemctl start nginx
sudo systemctl enable nginx

# unlink default virtual host
#sudo unlink /etc/nginx/sites-enabled/default

echo "server {
  listen 80;
  listen [::]:80 ipv6only=on;

  server_name myapps.me.us;
 
  access_log /var/log/nginx/reverse-access.log;
  error_log /var/log/nginx/reverse-error.log;
  
  location / {

  }

  location /api1 {
    proxy_pass http://192.168.64.10:3001;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host $host;
    proxy_cache_bypass $http_upgrade;

  }

  location /api2 {
    proxy_pass http://192.168.64.10:3002;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host $host;
    proxy_cache_bypass $http_upgrade;

  }

}" > /etc/nginx/sites-available/reverse-proxy.conf

# copy config file from sites-available to sites-enabled. Use symbolic link
sudo ln -s /etc/nginx/sites-available/reverse-proxy.conf /etc/nginx/sites-enabled/reverse-proxy.conf

sleep 2

# test config file
sudo nginx -t

# restart web server
sudo systemctl restart nginx