#!/bin/bash
set -e

FTP_PASSWORD=$(cat /run/secrets/ftp_password)

# create empty directory for privilege separation
mkdir -p /var/run/vsftpd/empty

id -u ftpuser &>/dev/null || useradd -d /var/www/wordpress -M ftpuser
printf 'ftpuser:%s\n' "$FTP_PASSWORD" | chpasswd

cat << EOF > /etc/vsftpd.conf
listen=YES

anonymous_enable=NO
local_enable=YES
write_enable=YES

local_root=/var/www/wordpress
chroot_local_user=YES
allow_writeable_chroot=YES

pasv_enable=YES
pasv_min_port=21000
pasv_max_port=21100

# disable seccomp sandbox to avoid docker related issues 
seccomp_sandbox=NO
background=NO
EOF

exec vsftpd /etc/vsftpd.conf
