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
sudo apt install -y php7.1-fpm php7.1-mbstring php7.1-xml php7.1-mysql php7.1-common php7.1-gd php7.1-json php7.1-cli php7.1-curl
sudo apt-get install -y php-zip
sudo systemctl start php7.1-fpm
sudo apt-get install -y composer

echo "-- Install and Start Laravel --"
cd /vagrant

# composer install
wget https://getcomposer.org/download/1.6.3/composer.phar
sudo mv composer.phar /usr/local/bin/composer

sudo rm /etc/nginx/sites-available/default
sudo rm /etc/nginx/nginx.conf
sudo ln -s /vagrant/nginx-default /etc/nginx/sites-available/default
sudo ln -s /vagrant/nginx-config /etc/nginx/nginx.conf
sudo service nginx restart
sudo service nginx reload
sudo cp preset-env .env
sudo rm preset-env
php artisan key:generate
cd ..
sudo chown -R www-data /vagrant

echo "-- Provisioning Complete! You will need perform your first migration. --"





