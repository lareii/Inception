#!/bin/bash

mkdir -p /etc/nginx/ssl

# -nodes -> no encryption for this key
# -x509  -> certificate standard
openssl req -x509 -nodes -days 365 -newkey rsa:4096 \
    -keyout /etc/nginx/ssl/${DOMAIN_NAME}.key \
    -out /etc/nginx/ssl/${DOMAIN_NAME}.crt \
    -subj "/C=TR/ST=Kocaeli/L=Kocaeli/O=42Kocaeli/OU=Student/CN=${DOMAIN_NAME}"

envsubst '$DOMAIN_NAME' < /etc/nginx/conf.d/default.conf.tpl > /etc/nginx/conf.d/default.conf

exec nginx -g "daemon off;"
