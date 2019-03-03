#!bin/bash

read -p "Name of your site without http:// and with .com(or whatever)>" siteurl
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
        mysql -u root -p$MYPASS -Bse "CREATE DATABASE $dbname;GRANT ALL PRIVILEGES ON $dbname.* TO $dbuser@localhost IDENTIFIED BY '$dbpass';FLUSH PRIVILEGES;"
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
        " > /etc/nginx/sites-available/$siteurl
        systemctl reload nginx
}

Install_PHPextensions () {

        echo "INSTALLNG ADDITIONAL PHP EXTENSIONS"
        apt-get install -y php-curl php-gd php-mbstring php-mcrypt php-xml php-xmlrpc
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
        cat "source /root/wp-completion.bash" >> ~/.bashrc
        source ~/.bashrc
        mkdir /var/www/$siteurl
        cd /var/www/$siteurl
        #wp core download --allow-root
        chown -R $USER:www-data /var/www/$siteurl
        sudo -u www-data wp core download
        sudo -u www-data wp core config --dbname="$dbname" --dbuser="$dbuser" --dbpass="$dbpass" --dbhost="localhost" --dbprefix="wp_"
        read -p "Type the admin of the wordpress >" adminuser
        read -p "Type the password of the admin >" password
        read -p "Type the email of the admin >" adminemail
        sudo -u www-data wp core install --url="http://$siteurl" --title="Blog $siteurl" --admin_user="$adminuser" --admin_password="$password" --admin_email="$adminemail"
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
