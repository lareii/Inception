FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates \
    curl php-cli php-mysql && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

RUN curl -o index.php https://www.adminer.org/static/download/5.4.2/adminer-5.4.2.php

EXPOSE 8080

ENTRYPOINT ["php", "-S", "0.0.0:8080", "-t", "/var/www/html"]
