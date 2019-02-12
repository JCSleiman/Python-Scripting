#!/bin/bash

# You need to run the script LEMP.sh before this one

read -p "Choose the route to install Magento (skip the '/' at the end) > " RT
read -p "WRITE THE URL OF YOUR SITE (WITHOUT HTTP://) > " SITEURL

Magento_Installation () {
    
    echo "INSTALLING MAGENTO TAR INTO $RT"	
    cd $RT
    wget https://github.com/magento/magento2/archive/2.3.tar.gz
    tar -xzvf 2.3.tar.gz
    mv magento2-2.3/ magento2/
    echo "CHANGING PERMISSIONS AND OWNERSHIP"
    cd $RT/magento2
    find var vendor pub/static pub/media app/etc -type f -exec chmod g+w {} \;
    find var vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} \;
    chown -R :www-data .
    chmod u+x bin/magento
}

Composer_Installation () {

    echo "INSTALLING COMPOSER GLOBALY"
    curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/bin --filename=composer
    cd $RT/magento2
    composer install -v

    cd $RT/magento2/bin
    echo "MAGENTO SETUP AND INSTALLATION"
    ./magento setup:install --base-url=http://$SITEURL --db-host=localhost --db-name=magento --db-user=magento --db-password=magento --admin-firstname=admin --admin-lastname=admin --admin-email=admin@admin.com --admin-user=admin --admin-password=admin123 --language=en_US --currency=USD --timezone=America/Chicago --use-rewrites=1
    echo "
    MAGENTO_DB_NAME=magento
    MAGENTO_DB_USER=magento
    MAGENTO_DB_PASSWORD=magento
    MAGENTO_ADMIN_FIRSTNAME=admin
    MAGENTO_ADMIN_LASTNAME=admin
    MAGENTO_ADMIN_EMAIL=admin@admin.com
    MAGENTO_ADMIN_USER=admin
    MAGENTO_ADMIN_PASSWORD=admin123
    "
    sleep 2
    echo "CHANGING TO DEVELOPER MODE TO GET THE NGINX CONFIGURATION"
    cd $RT/magento2/bin
     ./magento deploy:mode:set developer
}

Nginx_Config () {

    echo "CREATING THE NGINX CONFIG"
    touch /etc/nginx/sites-available/magento.conf
    echo "
upstream fastcgi_backend {
     server  unix:/run/php/php7.0-fpm.sock;
 }

 server {

     listen 80;
     server_name $SITEURL;
     set $MAGE_ROOT $RT/magento2;
     include $RT/magento2/nginx.conf.sample;
 }" > /etc/nginx/sites-available/magento.conf
     echo "SYMLINKING INTO SITES-ENABLED"
     ln -s /etc/nginx/sites-available/magento /etc/nginx/sites-enabled
     systemctl restart nginx
}

if [ $USER == root ]
then
    Magento_Installation
    Composer_Installation
    Nginx_Config
else
    echo "You must run the script with super user privileges"
fi
