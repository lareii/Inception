FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y --no-install-recommends redis-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 6379

# allkeys-lru: delete first the least recently used keys when maxmemory limit is reached
ENTRYPOINT ["redis-server", "--bind", "0.0.0.0", "--daemonize", "no", "--protected-mode", "no", \
             "--maxmemory", "256mb", "--maxmemory-policy", "allkeys-lru"]
