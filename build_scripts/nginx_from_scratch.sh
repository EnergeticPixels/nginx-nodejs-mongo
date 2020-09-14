#!/usr/bin/env bash

set -e

# ******************************************************
#         Application versions 
#     Keep this up to date
# ******************************************************
PCRE_VER=8.44
ZLIB_VER=1.2.11
OPENSSL_VER=1.1.1g
NGINX_VER=1.19.2

# **** The below build utilities come from build_tools.sh in my project ****
# **** uncomment if you are running this without the script to install them ****
#sudo apt-get update
#sudo apt-get install -y build-essential git tree locate

#**************************************************************************
# Environment Variables: KEEP UP TO DATE WITH MOST RECENT VERSION NUMBERS
#
#   Directory where all downloaded tar ball files live temporarily. This 
#   directory and all contents will be removed after nginx is successfully
#   built and installed.
DOWNLOAD_FOLDER=/usr/local/DOWNLOAD
#   Name of the folder where un-tar'd source files will be stored and used to
#   compile NGINX.  This directory and all contents will be removed after nginx
#   is successfully built and installed. 
UNZIPPED_FOLDER=/usr/local/src_files
#****************************************************************************

# ***************************************************************************
# BEGIN SCRIPT EXECUTION
# ***************************************************************************
sudo apt-get update

sudo mkdir -p $UNZIPPED_FOLDER
sudo mkdir -p $DOWNLOAD_FOLDER

# TEMPORARY requirements until I find source to compile from
#     REQUIRED FOR --with-http_xslt_module=dynamic nginx ./configure
sudo apt-get install -y libxml2 libxml2-dev libxslt1.1 libxslt1-dev
#     REQUIRED FOR --with-http_image_filter_module=dynamic nginx ./configure
sudo apt-get install -y libgd3 libgd-dev
#     REQUIRED FOR --with-stream_geoip_module nginx ./configure
sudo apt-get install -y libgeoip1 libgeoip-dev geoip-bin
#     REQUIRED FOR --with-http_perl_module=dynamic nginx ./configure
sudo apt-get install -y perl libperl-dev
#     REQUIRED FOR FIREWALL OPS
sudo apt-get install -y ufw

cd $DOWNLOAD_FOLDER

# check files -> download
if [ ! -f pcre-${PCRE_VER}.tar.gz ]; then
	echo "PCRE tar file does not exist! "
	echo "Begin download"
	wget -c ftp://ftp.pcre.org/pub/pcre/pcre-${PCRE_VER}.tar.gz
fi
if [ ! -f zlib-${ZLIB_VER}.tar.gz ]; then
	echo "ZLIB tar file does not exist! "
	echo "Begin download"
	wget -c http://zlib.net/zlib-${ZLIB_VER}.tar.gz
fi
if [ ! -f openssl-${OPENSSL_VER}.tar.gz ]; then
	echo "OPENSSL tar file does not exist! "
	echo "Begin download"
	wget -c https://www.openssl.org/source/openssl-${OPENSSL_VER}.tar.gz
fi
if [ ! -f nginx-${NGINX_VER}.tar.gz ]; then
	echo "NGINX tar file does not exist! "
	echo "Begin download"
	wget -c http://nginx.org/download/nginx-${NGINX_VER}.tar.gz
fi

# check files -> un-tar them
sudo tar zxvf pcre-${PCRE_VER}.tar.gz -C ${UNZIPPED_FOLDER}
sudo tar zxvf zlib-${ZLIB_VER}.tar.gz -C ${UNZIPPED_FOLDER}
sudo tar zxvf openssl-${OPENSSL_VER}.tar.gz -C ${UNZIPPED_FOLDER}
sudo tar zxvf nginx-${NGINX_VER}.tar.gz -C ${UNZIPPED_FOLDER}

# copy nginx manual page to /usr/share/man/man8/ directory
if [ ! -f /usr/share/man/man8/nginx.8.gz ]; 
then 
sudo cp $UNZIPPED_FOLDER/nginx-${NGINX_VER}/man/nginx.8 /usr/share/man/man8
sudo gzip /usr/share/man/man8/nginx.8
ls /usr/share/man/man8/ | grep nginx.8.gz
# check that Man page for NGINX is working
# uncomment line below for troubleshooting
#man nginx
fi

cd $UNZIPPED_FOLDER/nginx-${NGINX_VER}

# NGINX COMPILING CONFIGURATION
./configure --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --build=Debian --with-http_stub_status_module --with-http_gzip_static_module --with-http_sub_module --with-pcre=${UNZIPPED_FOLDER}/pcre-${PCRE_VER} --with-pcre-jit --with-zlib=${UNZIPPED_FOLDER}/zlib-${ZLIB_VER} --with-openssl=${UNZIPPED_FOLDER}/openssl-${OPENSSL_VER} --with-http_ssl_module --with-compat --with-debug --with-http_auth_request_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_image_filter_module=dynamic --with-http_mp4_module --with-http_perl_module=dynamic --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_stub_status_module --with-http_v2_module --with-http_xslt_module=dynamic --with-mail_ssl_module --with-mail --with-mail=dynamic --with-poll_module --with-stream --with-stream_geoip_module --with-stream_geoip_module=dynamic --with-stream_ssl_module --with-stream_ssl_preread_module --with-stream=dynamic --with-threads --with-openssl-opt=enable-ec_nistp_64_gcc_128 --with-openssl-opt=no-nextprotoneg --with-openssl-opt=no-weak-ssl-ciphers --with-openssl-opt=no-ssl3 

sudo make
sudo make install

# Symlink /usr/lib/nginx/modules to /etc/nginx/modules. This is a standard place for Nginx modules.
mkdir -p /etc/nginx/modules
sudo ls -s /usr/lib/nginx/modules /etc/nginx/modules

# Create a directory at /var/lib/nginx to prevent the NGINX config 
# file from failing verification in next command (sudo nginx -t)
sudo mkdir -p /var/lib/nginx

# Verify NGINX version and verify configuration options match what
# was specified with the ./configure command
echo
echo 'Verify NGINX version and config options below:'
echo
sudo nginx -t && sudo nginx -v && sudo nginx -V

# Create folders for nginx multiple virtual host config
sudo mkdir /etc/nginx/{conf.d,snippets,sites-available,sites-enabled}

# Create firewall app profile (UFW) for NGINX
# If provisioning an Amazon EC2 instance this does not need to be enabled
# if the same rule set is applied via security group
sudo touch nginx
echo '[Nginx HTTP]' | sudo tee -a nginx
echo 'title=Web Server (Nginx, HTTP)' | sudo tee -a nginx
echo 'description=Small, but very powerful and efficient web server' | sudo tee -a nginx
echo 'ports=80/tcp' | sudo tee -a nginx
echo | sudo tee -a nginx
echo '[Nginx HTTPS]' | sudo tee -a nginx
echo 'title=Web Server (Nginx, HTTPS)' | sudo tee -a nginx
echo 'description=Small, but very powerful and efficient web server' | sudo tee -a nginx
echo 'ports=443/tcp' | sudo tee -a nginx
echo | sudo tee -a nginx
echo '[Nginx Full]' | sudo tee -a nginx
echo 'title=Web Server (Nginx, HTTP + HTTPS)' | sudo tee -a nginx
echo 'description=Small, but very powerful and efficient web server' | sudo tee -a nginx
echo 'ports=80,443/tcp' | sudo tee -a nginx

# Move the file so UFW can read it. UFW is disabled by default
sudo mv nginx /etc/ufw/applications.d/nginx

# Create systemd unit file for NGINX
sudo touch nginx.service
echo '[Unit]' | sudo tee -a nginx.service
echo 'Description=A high performance web server and a reverse proxy server' | sudo tee -a nginx.service
echo 'After=network.target' | sudo tee -a nginx.service
echo | sudo tee -a nginx.service
echo '[Service]' | sudo tee -a nginx.service
echo 'Type=forking' | sudo tee -a nginx.service
echo 'PIDFile=/run/nginx.pid' | sudo tee -a nginx.service
echo $'ExecStartPre=/usr/sbin/nginx -t -q -g \'daemon on; master_process on;\'' | sudo tee -a nginx.service
echo $'ExecStart=/usr/sbin/nginx -g \'daemon on; master_process on;\'' | sudo tee -a nginx.service
echo $'ExecReload=/usr/sbin/nginx -g \'daemon on; master_process on;\' -s reload' | sudo tee -a nginx.service
echo 'ExecStop=-/sbin/start-stop-daemon --quiet --stop --retry QUIT/5 --pidfile /run/nginx.pid' | sudo tee -a nginx.service
echo 'TimeoutStopSec=5' | sudo tee -a nginx.service
echo 'KillMode=mixed' | sudo tee -a nginx.service
echo | sudo tee -a nginx.service
echo '[Install]' | sudo tee -a nginx.service
echo 'WantedBy=multi-user.target' | sudo tee -a nginx.service

# Move the file to correct location so NGINX can be started,
# stopped and reloaded with global commands
sudo mv nginx.service /etc/systemd/system/nginx.service

# Nginx, by default, generates backup .default files in /etc/nginx
sudo rm /etc/nginx/*.default

# Change permissions and group ownership of Nginx log files.
#sudo chmod 640 /var/log/nginx/*
#sudo chown nginx /var/log/nginx/*

# Create log rotation config for NGINX and populate it
echo "/var/log/nginx/*.log {
    daily
    missingok
    rotate 52
    compress
    delaycompress
    notifempty
    create 640 nginx nginx
    sharedscripts
    postrotate
      if [ -f /var/run/nginx.pid ]; then
              kill -USR1 `cat /var/run/nginx.pid`
      fi
    endscript
}" > /etc/logrotate.d/nginx

# Validate that UFW application profiles are created and recognized.
sudo ufw app list

# Start and enable NGINX service
sudo systemctl start nginx.service && sudo systemctl enable nginx.service

# Verify NGINX is running
sudo systemctl status nginx.service



# Remove all source files
cd $DOWNLOAD_FOLDER
sudo rm -rf *.tar.gz
#cd $UNZIPPED_FOLDER
#sudo rm -rf *.*