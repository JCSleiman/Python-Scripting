#!bin/bash

read -p "Name of your site without http:// >"siteurl
read -p "TYPE THE MYSQL ROOT PASSWORD > " MYPASS
echo "Database Name: "
read -e dbname
echo "Database User: "
read -e dbuser
echo "Database Password: "
read -s dbpass

create_mysqlDBandUser () {

	echo "===== WORDPRESS INSTALL SCRIPT ====="
	echo "LETS CREATE A DATABASE AND USER FOR OUR WORDPRESS"
	mysql -u root -p$MYPASS -Bse "CREATE DATABASE $dbname DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;GRANT ALL ON $dbname.* TO '$dbuser'@'localhost' IDENTIFIED BY '$dbpass';FLUSH PRIVILEGES;EXIT;"
	echo "===== MAKING THE CHANGES TO THE NGINX CONFIG ====="
	echo "
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/$siteurl;
    index index.php index.html index.htm index.nginx-debian.html;

    server_name $siteurl;

    location / {
        #try_files $uri $uri/ =404;
        try_files $uri $uri/ /index.php$is_args$args;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php7.2-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }

    location = /favicon.ico { log_not_found off; access_log off; }
    location = /robots.txt { log_not_found off; access_log off; allow all; }
    location ~* \.(css|gif|ico|jpeg|jpg|js|png)$ {
        expires max;
        log_not_found off;
    }
}
	" > /etc/nginx/sites-available/default	
	systemctl reload nginx
}

Install_PHPextensions () {

	echo "INSTALLNG ADDITIONAL PHP EXTENSIONS"
        apt-get install php-curl php-gd php-mbstring php-mcrypt php-xml php-xmlrpc
	#This restart depends on what version of php-fpm you have.
	systemctl restart php7.2-fpm
}

Download_Wordpress () {

	cd /tmp
	apt install curl -y
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x wp-cli.phar
	mv wp-cli.phar /usr/local/bin/wp
	cd ~
	wget https://github.com/wp-cli/wp-cli/raw/master/utils/wp-completion.bash
	cat "source ~/wp-completion.bash" >> ~/.bashrc
	wp core download
	cd /var/www/$siteurl
	#curl -O https://wordpress.org/latest.tar.gz
	#tar xzvf latest.tar.gz
	#cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php
	#mkdir /tmp/wordpress/wp-content/upgrade
	#cp -a /tmp/wordpress/. /var/www/$siteurl
	chown -R www-data:www-data public_html
	cd public_html
	-u www-data wp core download
	-u www-data wp core config --dbname='$dbname' --dbuser='$dbuser' --dbpass='$dbpass' --dbhost='localhost' --dbprefix='wp_'
	read -p "Type the admin of the wordpress >" adminuser
	read -p "Type the password of the admin >" password
	read -p "Type the email of the admin >" adminemail
	-u www-data wp core install --url='http://$siteurl' --title='Blog $siteurl' --admin_user='$adminuser' --admin_password='$password' --admin_email='$adminemail'
	#chmod g+w /var/www/$siteurl/wp-content
	#chmod -R g+w /var/www/$siteurl/wp-content/themes
	#chmod -R g+w /var/www/$siteurl/wp-content/plugins
	#echo "REPLACING DB LINES INTO WP-CONFIG.PHP"
	#sed s/define('DB_NAME', 'database_name_here');/define('DB_NAME', '$dbname');/g /var/www/$siteurl/wp-config.php
	#sed s/define('DB_USER', 'username_here');/define('DB_NAME', '$dbuser');/g /var/www/$siteurl/wp-config.php
	#sed s/define('DB_PASSWORD', 'password_here');/define('DB_PASSWORD', '$dbpass');/g /var/www/$siteurl/wp-config.php
	#sed s/define('DB_COLLATE', '');/define('DB_COLLATE', '');\ndefine('FS_METHOD', 'direct');/g /var/www/$siteurl/wp-config.php

	echo "AUTOMATE COMPLETE"

}

if [ $USER == root ]
then
      create_mysqlDBandUser
      Install_PHPextensions
      Download_Wordpress
else
    echo "You must run the script with super user privileges"
fi

