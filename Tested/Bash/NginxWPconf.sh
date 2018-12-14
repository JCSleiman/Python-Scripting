server {
        server_name www.SITE SITE;
        listen IPV4:80;
        root /var/www/SITE;
        index index.php index.html index.htm;

        access_log /var/log/nginx/SITE_access_log;
        error_log /var/log/nginx/SITE_error_log;     

        location / {
                try_files $uri $uri/ /index.php?q=$uri&$args;
                fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                include fastcgi_params;
        }
        
        location ~ \.php$ {
                try_files $uri $uri/ /index.php?q=$uri&$args;
                fastcgi_pass unix:/run/php/php7.2-fpm.sock;
                #fastcgi_pass unix:/run/php/php5.6-fpm.sock;
                #fastcgi_pass 127.0.0.1:9000;
		fastcgi_read_timeout 180;
                fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                include fastcgi_params;
        }

        location ~* \.(js|css|ico|gif|jpeg|jpg|png|woff|ttf|otf|svg|woff2|eot)$ {
                expires 30d;
                add_header Pragma public;
                add_header Cache-Control "public";
        }

        location = /xmlrpc.php {
            deny all;
        }

        location ~* ^/wp-content/uploads/.*.(html|htm|shtml|php|js|swf)$ {
            deny all;
        }

        location ~* wp-config.php {
            deny all;
        }
        location ~* wp-admin/includes { deny all; }
        location ~* wp-includes/themes/ { deny all; }
        location /wp-includes/ { internal; }
        location ~* \.(?:bak|MD|sql|tar\.gz|tgz|txt) { return 404; }
}
