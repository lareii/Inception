#!/bin/bash
set -e # stop the script if any command fails

DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

chown -R www-data:www-data /var/www/wordpress

mkdir -p /run/php
chown -R www-data:www-data /run/php

if [ -f /etc/php/8.2/fpm/pool.d/www.conf ]; then
    sed -i 's|listen = /run/php/php8.2-fpm.sock|listen = 9000|g' /etc/php/8.2/fpm/pool.d/www.conf
fi

# depends-on in compose file is not enough to ensure db is ready
# so we will wait for the database to be ready before starting PHP-FPM
until mariadb-admin ping -h"mariadb" -u${DB_USER} -p${DB_PASSWORD} --silent; do
    echo "wordpress: waiting for mariadb to be ready..."
    sleep 2
done

# allow-root is necessary because the entrypoint script is run as root
# but wp-cli needs to be run as www-data
if [ ! -f "wp-config.php" ]; then
    wp core download --allow-root

    wp config create --allow-root \
        --dbname=$DB_NAME \
        --dbuser=$DB_USER \
        --dbpass=$DB_PASSWORD \
        --dbhost=mariadb:3306

    wp core install --allow-root \
        --url=$DOMAIN_NAME \
        --title="$SITE_TITLE" \
        --admin_user=$WP_ADMIN_USERNAME \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --skip-email

    wp user create $WP_USER_USERNAME $WP_USER_EMAIL \
        --role=editor \
        --user_pass=$WP_USER_PASSWORD \
        --allow-root

    # add redis configuration to wp-config.php:L41
    sed -i "41 i define( 'WP_REDIS_HOST', 'redis' );\ndefine( 'WP_REDIS_PORT', '6379' );\n" wp-config.php

    wp plugin install redis-cache --activate --allow-root
    wp redis enable --allow-root
fi

# dont demonize php-fpm. if pid 1 process is not running or demonized, the container will stop
exec php-fpm8.2 -F
