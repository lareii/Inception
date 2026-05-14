FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y --no-install-recommends vsftpd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ./tools/entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/entrypoint.sh

# 20: FTP data transfer (not used in passive mode)
# 21: FTP control (login, commands)

# 21000-21100: Passive FTP data transfer ports
# these ports for passive FTP data transfer, when port 20 is blocked by firewall,
# the FTP server can use these ports for data transfer instead of port 20.
EXPOSE 21 21000-21100

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
