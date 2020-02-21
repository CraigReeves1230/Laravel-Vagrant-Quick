#!/usr/bin/env bash

"-- install Nodejs --"
cd ~
curl -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh
sudo bash nodesource_setup.sh
sudo apt-get install -y nodejs

echo "-- Updating Apt-Get --"
sudo apt-get update

echo "-- Installing PostgreSQL --"
sudo apt-get -y install wget postgresql postgresql-contrib
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'postgres';"

echo "-- Installing git, Java and other dependencies --"
sudo apt-get -y install vim lsof git-core default-jre curl zlib1g-dev build-essential
libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev
python-software-properties libffi-dev beanstalkd

echo "-- Installing NGinX --"
sudo apt-get install -y nginx
sudo ufw allow 'Nginx HTTP'

echo "-- Installing PHP --"
sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt-get update
sudo apt-get install -y php7.3
sudo apt-cache search php7.3
sudo apt install -y php7.3-fpm php7.3-mbstring php7.3-xml php7.3-pgsql php7.3-opcache php-mongodb php7.3-common php7.3-gd php7.3-json php7.3-cli php7.3-curl
sudo apt-get install -y php7.3-zip
sudo update-alternatives --set php /usr/bin/php7.3
sudo service php7.3-fpm restart

echo "-- Installing Redis --"
sudo apt-get update
sudo apt-get -y install build-essential tcl
cd /tmp
curl -O http://download.redis.io/redis-stable.tar.gz
tar xzvf redis-stable.tar.gz
cd redis-stable
make
sudo make install
cd /vagrant

echo "-- Install PHPRedis --"
cd /
sudo apt-get -y install php7.3-dev
sudo apt-get -y install unzip
sudo apt-get -y install gcc make autoconf libc-dev pkg-config
cd /tmp
sudo wget https://github.com/phpredis/phpredis/archive/master.zip -O phpredis.zip
sudo unzip -o /tmp/phpredis.zip && mv /tmp/phpredis-* /tmp/phpredis && cd /tmp/phpredis && phpize && ./configure && make && sudo make install
sudo touch /etc/php/7.3/mods-available/redis.ini && echo extension=redis.so > /etc/php/7.3/mods-available/redis.ini
sudo ln -s /etc/php/7.3/mods-available/redis.ini /etc/php/7.3/fpm/conf.d/redis.ini
sudo ln -s /etc/php/7.3/mods-available/redis.ini /etc/php/7.3/cli/conf.d/redis.ini
sudo apt -y install php7.3-bcmath
sudo ./configure --enable-redis-igbinary

echo "-- Install XDebug --"
cd /
pecl install xdebug
sudo echo "zend_extension=/usr/lib/php/20180731/xdebug.so" >> /etc/php/7.3/fpm/php.ini
sudo echo "xdebug.remote_enable = 1" >> /etc/php/7.3/fpm/php.ini
sudo echo "xdebug.remote_port = 9000" >> /etc/php/7.3/fpm/php.ini
sudo echo "xdebug.idekey = PHPSTORM" >> /etc/php/7.3/fpm/php.ini
sudo echo "xdebug.show_error_trace = 1" >> /etc/php/7.3/fpm/php.ini
sudo echo "xdebug.remote_autostart = 0" >> /etc/php/7.3/fpm/php.ini
sudo echo "xdebug.remote_connect_back = 1" >> /etc/php/7.3/fpm/php.ini
sudo service php7.3-fpm restart

cd /vagrant
sudo redis-server redis.conf

echo "-- Install Composer and Laravel --"

# composer install
wget https://getcomposer.org/download/1.6.3/composer.phar
sudo chmod 755 composer.phar
sudo mv composer.phar /usr/local/bin/composer

#Install Laravel
composer install

# NPM install components
npm install

#Additional configurations and installations
sudo npm install -g laravel-echo-server
sudo cp bootstrap_js.js resources/js/bootstrap.js
sudo cp app_js.js  resources/js/app.js
sudo npm run dev
sudo cp laravel_echo_server_service /etc/systemd/system/laravel-echo-server.service
sudo systemctl daemon-reload
sudo service laravel-echo-server start

sudo rm /etc/nginx/sites-available/default
sudo rm /etc/nginx/nginx.conf
sudo ln -s /vagrant/nginx-default /etc/nginx/sites-available/default
sudo ln -s /vagrant/nginx-config /etc/nginx/nginx.conf
sudo fuser -k 80/tcp
sudo service nginx restart
sudo service nginx reload
sudo cp preset-env .env
sudo rm preset-env
cd ..
sudo chown -R www-data /vagrant
sudo chmod -R 777 /vagrant/storage

cd /vagrant
sudo php artisan key:generate

echo "-- Provisioning Complete! You will need perform your first migration. --"


