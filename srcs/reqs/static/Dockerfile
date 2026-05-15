FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y --no-install-recommends python3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY ./files/index.html /var/www/html/index.html
COPY ./files/server.py .

EXPOSE 4242

ENTRYPOINT ["python3", "server.py"]
