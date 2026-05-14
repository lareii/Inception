#!/bin/bash
set -e

# -t: document root, target directory
exec php -S 0.0.0.0:8080 -t /var/www/html
