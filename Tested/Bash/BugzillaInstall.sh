#!/bin/bash
apt install -y perl
sudo useradd -d /home/bugzilla -m bugzilla
sudo passwd bugzilla
read -p "Password mysql" MYPASS
mysql -u root -p$MYPASS -Bse "create database bugzilla;grant all privileges on bugzilla.* to bugzilla@localhost;FLUSH PRIVILEGES;"
apt install -y apache2
cat "
Alias /bugzilla/ /var/www/bugzilla/
<directory /var/www/bugzilla>
Addhandler cgi-script .cgi .pl
Options +Indexes +ExecCGI +FollowSymLinks
DirectoryIndex index.cgi
AllowOverride Limit
</directory>
" >> /etc/apache2/apache2.conf
sudo useradd -d /home/apache2 -m apache2
sudo passwd apache2
cat "
export APACHE_RUN_USER=apache2
export APACHE_RUN_GROUP=apache2
" >> /etc/apache2/envvars
sudo tar -xvf bugzilla-4.0.2.tar
sudo mv /download/bugzilla-4.0.2 /usr/local/
sudo ln -s /usr/local/bugzilla-4.0.2 /var/www/bugzilla
sudo chown -R www-data:www-data /var/www/bugzilla
cd /var/www/bugzilla/
sudo ./checksetup.pl --check-modules
sudo perl -MCPAN -e install



