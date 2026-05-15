FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN curl -LO https://github.com/portainer/portainer/releases/download/2.39.2/portainer-2.39.2-linux-amd64.tar.gz && \
    tar -xzf portainer-2.39.2-linux-amd64.tar.gz && \
    rm portainer-2.39.2-linux-amd64.tar.gz

EXPOSE 9000

ENTRYPOINT ["/app/portainer/portainer"]
