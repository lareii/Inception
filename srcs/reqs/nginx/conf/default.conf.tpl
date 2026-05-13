server {
    listen              443 ssl;
    server_name         $DOMAIN_NAME;

    ssl_protocols       TLSv1.2;
    ssl_certificate     /etc/nginx/ssl/$DOMAIN_NAME.crt; # public key
    ssl_certificate_key /etc/nginx/ssl/$DOMAIN_NAME.key; # private key

    root                /var/www/wordpress;
    index               index.php index.html; # index.html fallback

    # regex pattern, handle all files ends with .php
    location ~ \.php$ {
        # index.php/wp-json/v2/posts
        # fastcgi_script_name -> /index.php
        # fastcgi_path_info -> /wp-json/v2/posts
        fastcgi_split_path_info ^(.+\.php)(/.+)$;

        fastcgi_pass wordpress:9000;
        # use this file if only directory given
        fastcgi_index index.php;

        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
    }
}
