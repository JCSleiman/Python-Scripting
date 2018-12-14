#!/bin/bash


# Just run this script after running the LEMP.sh script.

Update_repositories () {
    echo "INSTALLING DEPENDENCIES"
    echo "UPDATING NGINX REPOSITORIES"
    add-apt-repository -y ppa:nginx/stable &>/dev/null && echo "OK" || echo "Failed" 
    echo "ADDING ONDREJ/PHP REPOSITORIES"
    add-apt-repository -y ppa:ondrej/php &>/dev/null && echo "Ok" || echo "Failed"
    apt update &>/dev/null
    apt install -y software-properties-common &>/dev/null && echo "OK" || echo "Failed"
    apt install -y expect &>/dev/null
}

Install_Composer () {

    echo "INSTALLING COMPOSER"
    apt install composer -y &>/dev/null && echo "OK" || echo "Failed"
}

Configure_Nginx_4_Laravel () {

    echo "CREATING /var/www/laravel directory"
    mkdir -p /var/www/laravel
    cd /etc/nginx/sites-available
    echo "APPENDING THE LARAVEL CONFIGURATION INTO NGINX"
    cat /route/to/NginxLaravelConfig.sh >> laravel.conf
    ln -s /etc/nginx/sites-available/laravel.conf /etc/nginx/sites-enabled/laravel
    systemctl reload nginx
}

Install_Laravel () {
	
    echo "INSTALL UNZIP"
    apt install unzip -y &>/dev/null && echo "OK" || echo "Failed"
    echo "CHANGING DIRECTORY TO /var/www/laravel"
    cd /var/www/laravel
    echo "TIME TO USE COMPOSER"
    composer create-project laravel/laravel . &>/dev/null && echo "OK" || echo "Failed"
    echo "CHANGE OWNERSHIP AND PERMISSION OF THE FOLDER"
    chown -R www-data:root /var/www/laravel
    chmod 755 /var/www/laravel/storage
    echo "LARAVEL INSTALLATION COMPLETED"
}
if [ $USER == root ]
then
    Update_repositories
    Install_Composer
    Configure_Nginx_4_Laravel
    Install_Laravel
else
    echo "You must run the script with super user privileges"
fi

