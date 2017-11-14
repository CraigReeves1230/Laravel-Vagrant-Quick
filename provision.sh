#!/usr/bin/env bash

echo "-- Updating Apt-Get --"
sudo apt-get update

echo "-- Installing MySQL --"
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password password'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password password'
sudo apt-get -y install mysql-server

echo "-- Installing node, git, Java and other dependencies --"
sudo apt-get -y install nodejs-legacy vim lsof git-core default-jre curl zlib1g-dev build-essential
libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev
python-software-properties libffi-dev

echo "-- Installing NGinX --"
sudo apt-get install -y nginx
sudo ufw allow 'Nginx HTTP'

echo "-- Installing PHP and Composer --"
sudo apt install -y php7.0-fpm php7.0-mbstring php7.0-xml php7.0-mysql php7.0-common php7.0-gd php7.0-json php7.0-cli php7.0-curl
sudo apt-get install -y php-zip
sudo systemctl start php7.0-fpm
sudo apt-get install -y composer

echo "-- Install and Start Laravel --"
cd /vagrant
composer install
sudo cp nginx-default /etc/nginx/sites-available/default
sudo cp nginx-config /etc/nginx/nginx.conf
sudo service nginx restart
sudo service nginx reload
sudo cp preset-env .env
sudo rm preset-env
php artisan key:generate
cd ..
sudo chown -R www-data /vagrant

echo "-- Provisioning Complete! You will need perform your first migration. --"





