#!/bin/bash

#Warn user to be sudo
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

Install_php72 (){
    echo "Installing PHP7.2 and extensions"
    apt install -y php7.2 php7.2-fpm php7.2-gd php7.2-mysql php7.2-dom php7.2-cli php7.2-json php7.2-common php7.2-mbstring php7.2-opcache php7.2-readline php7.2-xmlrpc php7.2-soap php7.2-xml php7.2-zip php7.2-curl php7.2-intl &>/dev/null && echo "Ok" || echo "Failed"
}

Install_nginx (){
    echo "Installing NGINX and PHP-FPM"
    apt -y install nginx &>/dev/null && echo "Ok" || echo "Failed"
}

Install_mysql(){
    echo "Installing MySQL"
    apt install -y mariadb-server mariadb-client &>/dev/null && echo "Ok" || echo "Failed"
    read -p 'Insert root password for MySQL: ' rootpasswd
    sudo mysql -u root -e  "use mysql;UPDATE user SET PASSWORD=PASSWORD('$rootpasswd') where user='root';update user set plugin='' where User='root';flush privileges"
}
Add_to_boot(){
    systemctl enable mysql.service
    systemctl enable nginx.service
    systemctl enable php7.2-fpm.service
}
Start_services(){
    systemctl start mysql.service
    systemctl start nginx.service
    systemctl start php7.2-fpm.service
}
if [ $USER == root ]
then
    Update_repositories
    Install_php72
    Install_nginx
    Install_mysql
    Add_to_boot
    Start_services
else
    echo "You must run the script with super user privileges"
fi
