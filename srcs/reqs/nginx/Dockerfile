FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y --no-install-recommends nginx openssl gettext-base && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ./conf/default.conf.tpl /etc/nginx/conf.d/default.conf.tpl
COPY ./tools/entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
