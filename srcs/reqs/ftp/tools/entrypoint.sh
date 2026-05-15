#!/bin/bash
set -e

FTP_PASSWORD=$(cat /run/secrets/ftp_password)

# create empty directory for privilege separation
mkdir -p /var/run/vsftpd/empty

id -u ftpuser &>/dev/null || useradd -d /var/www/wordpress -M ftpuser
printf 'ftpuser:%s\n' "$FTP_PASSWORD" | chpasswd

exec vsftpd /etc/vsftpd.conf
