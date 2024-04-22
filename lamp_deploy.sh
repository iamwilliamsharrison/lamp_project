#!/bin/bash

#update your linux system
sudo apt update

#install your apache webserver
sudo apt install apache2 -y

#add the php ondrej repository
sudo add-apt-repository --yes ppa:ondrej/php

#update your repository again
sudo apt update

# install php8.2
sudo apt install php8.2 -y

#install some of those php dependencies that are needed for laravel to work
sudo apt install php8.2-curl php8.2-dom php8.2-mbstring php8.2-xml php8.2-mysql zip unzip -y
sudo apt update
sudo apt install php-sqlite3 -y

#enable rewrite
sudo a2enmod rewrite

#restart your apache server
sudo systemctl restart apache2

#change directory in the bin directory
cd /usr/bin

# install composer
sudo curl -sS https://getcomposer.org/installer | sudo php -q

#move the content of the deafault composer.phar
sudo mv composer.phar composer
echo " you have successfully installed composer"

#change directory in /var/www directory so we can clone of laravel repo there
cd /var/www/
sudo git clone https://github.com/laravel/laravel.git
sudo chown -R $USER:$USER /var/www/laravel
cd laravel/

# install composer autoloader
cd /var/www/laravel
sudo composer install --optimize-autoloader --no-dev --quiet
composer update --quiet

#copy the content of the default env file to .env
sudo cp .env.example .env
sudo chown -R www-data:www-data /var/www/laravel
sudo chown -R www-data /var/www/laravel/storage
sudo chown -R www-data /var/www/laravel/bootstrap/cache

cd /etc/apache2/sites-available/
sudo touch proj.conf
sudo echo '<VirtualHost *:80>
    ServerName localhost
    DocumentRoot /var/www/laravel/public

    <Directory /var/www/laravel>
        AllowOverride All
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/laravel-error.log
    CustomLog ${APACHE_LOG_DIR}/laravel-access.log combined
</VirtualHost>' | sudo tee /etc/apache2/sites-available/proj.conf
sudo a2ensite proj.conf
sudo a2dissite 000-default.conf
sudo systemctl restart apache2

# Install mysql
sudo apt install mysql-server -y
sudo apt install mysql-client -y
sudo systemctl start mysql
sudo mysql -uroot -e "CREATE DATABASE project;"
sudo mysql -uroot -e "CREATE USER 'palmer'@'localhost' IDENTIFIED BY 'vagrant';"
sudo mysql -uroot -e "GRANT ALL PRIVILEGES ON project.* TO 'palmer'@'localhost';"
cd /var/www/laravel
sudo sed -i "23 s/^#//g" /var/www/laravel/.env
sudo sed -i "24 s/^#//g" /var/www/laravel/.env
sudo sed -i "25 s/^#//g" /var/www/laravel/.env
sudo sed -i "26 s/^#//g" /var/www/laravel/.env
sudo sed -i "27 s/^#//g" /var/www/laravel/.env
sudo sed -i '22 s/=sqlite/=mysql/' /var/www/laravel/.env
sudo sed -i '23 s/=127.0.0.1/=localhost/' /var/www/laravel/.env
sudo sed -i '24 s/=3306/=3306/' /var/www/laravel/.env
sudo sed -i '25 s/=laravel/=project/' /var/www/laravel/.env
sudo sed -i '26 s/=root/=palmer/' /var/www/laravel/.env
sudo sed -i '27 s/=/=vagrant/' /var/www/laravel/.env

sudo systemctl restart apache2
cd /var/www/laravel
sudo php artisan key:generate
sudo php artisan storage:link
sudo php artisan migrate
sudo php artisan db:seed
sudo systemctl restart apache2
