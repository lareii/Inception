#!/bin/bash

# allkeys-lru: delete first the least recently used keys when maxmemory limit is reached
exec redis-server --bind 0.0.0.0 --daemonize no --protected-mode no \
     --maxmemory 256mb --maxmemory-policy allkeys-lru
