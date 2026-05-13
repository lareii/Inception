#!/bin/bash
set -e # stop the script if any command fails

DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
DB_PASSWORD=$(cat /run/secrets/db_password)

# https://github.com/MariaDB/mariadb-docker/blob/fff6ab37913bbbe25bfc6c6ea6f095e4ad7a039c/12.3/Dockerfile#L120
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

INIT_FLAG="/var/lib/mysql/.init_done"

if [ ! -f "$INIT_FLAG" ]; then
    if [ ! -d "/var/lib/mysql/mysql" ]; then
        mysql_install_db --user=mysql --datadir=/var/lib/mysql
    fi

    # start temp deamon with socket only
    mysqld_safe --skip-networking --socket=/run/mysqld/mysqld.sock &
    
    until mysqladmin ping --socket=/run/mysqld/mysqld.sock --silent; do
        sleep 1
    done

    mysql --socket=/run/mysqld/mysqld.sock <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

    # stop temp deamon and create init flag
    mysqladmin --socket=/run/mysqld/mysqld.sock -uroot -p"${DB_ROOT_PASSWORD}" shutdown
    touch "$INIT_FLAG"
fi

# commenting bind address to set address to 0.0.0.0 by default
# https://github.com/MariaDB/mariadb-docker/blob/fff6ab37913bbbe25bfc6c6ea6f095e4ad7a039c/12.3/Dockerfile#L125
sed -i 's/^bind-address/#bind-address/' /etc/mysql/mariadb.conf.d/50-server.cnf

exec mysqld --user=mysql
