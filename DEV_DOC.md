# Developer Documentation
This guide provides technical details on how to set up, build, and manage the Inception architecture.

## 1. Setting Up the Environment from Scratch

### Prerequisites
- A Linux-based virtual machine.
- `Docker` and `Docker Compose` installed.
- `make` installed.
- `sudo` privileges (needed to edit the `/etc/hosts` file).
- An FTP client for connecting to the FTP container (optional)

### Configuration Files and Secrets
Before building the project, you must prepare the environment variables and secrets:

1. **Environment Variables:** 
    - Go to the `srcs/` folder.
    - Rename the `.env.example` file to `.env`.
    - Open `.env` and edit the variables to fit your environment. Specifically, make sure `VOLUMES_PATH` points to a valid path on your host machine (e.g., `/home/username/data`) and `DOMAIN_NAME` is correct.
2.  **Secrets:**
    - Go to the root folder.
    - Rename the `secrets_example/` folder to `secrets/`.
    - Open the `.txt` files inside and replace the dummy passwords with real, secure passwords.
3.  **Local Domain Routing:** Run `make hosts` in your terminal. This command automatically adds your `DOMAIN_NAME` to your machine's `/etc/hosts` file so your browser knows where to connect.

## 2. Building and Launching the Project
The project uses a `Makefile` to simplify Docker Compose commands. 

To build the Docker images and launch the containers, run:
```bash
make up
```
This command runs `docker compose up -d --build`. The `prepare` rule inside the Makefile automatically creates the necessary local volume directories on your host machine before starting the containers.

## 3. Managing Containers and Volumes
Here are the relevant commands provided by the Makefile and Docker to manage the project:

### Makefile Commands:
- `make up`: Builds images, creates volumes, and starts the containers in detached mode.
- `make down`: Stops all running containers and removes the default network.
- `make clean`: Stops containers, removes them, removes all unused images, and deletes Docker volumes.
- `make fclean`: Does everything `make clean` does, but also deletes the physical data folders on your host machine (defined by `VOLUMES_PATH`).
- `make re`: Runs `fclean` followed by `up` (a complete reset).

### Docker Commands
- View running containers: `docker ps`
- View container logs: `docker logs <container_name>` (e.g., `docker logs inception-wordpress`)
- Enter a running container: `docker exec -it <container_name> bash`

## 4. Data Storage and Persistence
By default, Docker containers lose all their data when they are destroyed. To prevent this, we use **Bind Mounts** with **Named Volumes**.

- Where is data stored? The data is physically stored on the Host machine's filesystem. The exact location is determined by the `VOLUMES_PATH` variable in your `srcs/.env` file.
- How does it persist? The `docker-compose.yml` maps local folders to specific paths inside the containers.
    - The MariaDB database saves to `${VOLUMES_PATH}/mariadb`, which is mounted to `/var/lib/mysql` inside the MariaDB container.
    - The WordPress website files save to `${VOLUMES_PATH}/wordpress`, which is mounted to `/var/www/wordpress` inside the WordPress, NGINX, and FTP containers.
- Even if you stop and delete the containers, your database and website files remain safely on your host machine. They will automatically reconnect the next time you run `make up`.
