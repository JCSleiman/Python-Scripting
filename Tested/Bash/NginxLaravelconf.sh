server {
         listen 80;
         listen [::]:80 ipv6only=on;
 
         # Log files for Debugging
         access_log /var/log/nginx/laravel-access.log;
         error_log /var/log/nginx/laravel-error.log;
 
         # Webroot Directory for Laravel project
         root /var/www/laravel/public;
         index index.php index.html index.htm;
 
         # Your Domain Name
         server_name localhost; # larevelsite.com;
 
         location / {
                 try_files $uri $uri/ /index.php?$query_string;
         }
 
         # PHP-FPM Configuration Nginx
         location ~ \.php$ {
                 try_files $uri =404;
                 fastcgi_split_path_info ^(.+\.php)(/.+)$;
                 fastcgi_pass unix:/run/php/php7.2-fpm.sock;
                 fastcgi_index index.php;
                 fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                 include fastcgi_params;
         }
 }
