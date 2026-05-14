FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates \
    curl php-cli php-mysql && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

RUN curl -o index.php https://www.adminer.org/static/download/5.4.2/adminer-5.4.2.php

COPY ./tools/entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
