*This project has been created as part of the 42 curriculum by ebabaogl.*

## Description
Inception is a system administration project from the 42 curriculum that introduces containerization with Docker. The goal is to build a small infrastructure for multiple services running in isolated containers, orchestrated through Docker Compose, and all of this is done inside a virtual machine. (that's why it's called Inception, lol)

The infrastructure includes 8 containers that communicate over a private Docker network:
- **NGINX:** the only container exposed to the host, serving HTTPS traffic on port 443 using a self-signed TLS certificate. It acts as a reverse proxy in front of WordPress.
- **WordPress + PHP-FPM:** runs the WordPress application and processes PHP requests forwarded by NGINX.
- **MariaDB:** stores the WordPress database. Not exposed outside the internal network.
- **Redis:** used as an object cache for WordPress, improving performance by caching database query results.
- **FTP:** provides FTP access to the WordPress source files.
- **Adminer:** a web-based database management tool, accessible at `http://$(DOMAIN_NAME):8080`.
- **A static website:** served by Python's built-in HTTP server on port 4242, accessible at `http://$(DOMAIN_NAME):4242`.
- **Portainer:** a web-based Docker management interface, accessible at `http://$(DOMAIN_NAME):9000`.

Each service runs in its own container built from a Debian (bookworm) base image. Containers are configured through environment variables loaded from a .env file, and persistent data (database files, WordPress source) is stored on the host through bind-mounted Docker volumes.

## Instructions

### Prerequisites
- A Linux-based virtual machine.
- `Docker` and `Docker Compose` installed.
- `make` installed.
- `sudo` privileges (needed to edit the `/etc/hosts` file).
- An FTP client for connecting to the FTP container (optional)

### Setup
1. Clone the repository and `cd` into it.
2. Rename the `.env.example` file to `.env` under `srcs/` and fill in the required environment variables.
3. Rename the `secrets_example/` directory to `secrets/` and fill in the required secrets. 
3. Add the domain to your hosts file:
```bash
make hosts
```
4. Build and start the containers:
```bash
make up  # or simply make
```
5. Open `https://$(DOMAIN_NAME)` in your browser and ta-da! (self-signed certificate warning is expected.)

## Resources
- https://docs.docker.com/engine/
- https://docs.docker.com/reference/cli/docker/
- https://docs.docker.com/reference/compose-file/
- https://nginx.org/en/docs/http/configuring_https_servers.html
- https://www.cyberciti.biz/faq/configure-nginx-to-use-only-tls-1-2-and-1-3/
- https://github.com/MariaDB/mariadb-docker/ (inspired Dockerfile and entrypoint script)
- https://mariadb.com/docs/server/server-management/install-and-upgrade-mariadb
- https://mariadb.com/docs/server/server-management/automated-mariadb-deployment-and-administration/docker-and-mariadb/installing-and-using-mariadb-via-docker
- https://make.wordpress.org/cli/handbook/guides/installing/
- https://github.com/rhubarbgroup/redis-cache/blob/develop/INSTALL.md

### AI
Google Gemini and Claude used to provide quick, detailed answers instead of writing entire projects. Here are some of the questions I asked them:
- "What are **cgroups** and **namespaces** in Linux kernel? How do they work together to provide isolation and resource management for containers?"
- "How **tini** works as an init system for containers?"
- "Is this configuration looking good? How can I improve it?"

## Project Description

### Use of Docker
This project uses Docker to package each service (NGINX, WordPress/PHP-FPM, MariaDB) as an independent, reproducible unit. Each service has its own Dockerfile under `srcs/requirements/<service>/`, built from a `debian:bookworm` base image as required by the subject. The three containers are orchestrated with `docker-compose.yml`, which defines their build context, environment, volumes, and network configurations.

### Main design choices
- Debian Bookworm as the base image for all three services (used penultimate version of Debian to avoid potential issues with the latest release).
- **Separation of concerns:** WordPress runs PHP-FPM only, NGINX is the only HTTP-facing service. They communicate over FastCGI through the internal Docker network.
- **Idempotent entrypoints:** each entrypoint script uses flags to ensure that initialization steps performed only once.
- MariaDB initialization via temporary `mysqld_safe` instead of `--bootstrap` (which runs with `--skip-grant-tables` and silently refuses `CREATE USER` / `GRANT`), the entrypoint starts a temporary daemon on a UNIX socket, runs the SQL, then shuts it down before `exec`-ing the `mysqld`.
- Redis used as an object cache for WordPress, configured with the `redis-cache` plugin and environment variables.

### Comparisions

#### Virtual Machines vs Docker
VMs are virtualize hardware with strong isolation, slow boot, heavy on RAM and disk. Besides containers are virtualize at the OS level (shared host kernel, isolation via **namespaces** and **cgroups**, and for Linux ofc.) fast startup, low overhead, smaller images, but tied to the host kernel and weaker isolation.

#### Secrets vs Environment Variables
Environment variables are simple but exposed (visible in `docker inspect`, etc.), while Docker secrets are mounted as files under `/run/secrets/`, hidden from inspect and process environment, and encrypted.

#### Docker Network vs Host Network
A user-defined bridge network gives each container its own network namespace and private IP, with service name DNS between containers and only explicitly published ports reachable from the host, so only NGINX's 443 is exposed and MariaDB stays unreachable from outside. Host networking would share the host's namespace directly, skipping NAT for slightly less overhead but losing isolation, port-conflict safety, and portability.

#### Docker Volumes vs Bind Mounts
Bind mounts map a specific host path into the container, named volumes are managed by Docker under `/var/lib/docker/volumes/`, more portable, and integrate with volume drivers.
