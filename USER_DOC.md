# User Documentation
This guide explains how to use and interact with the Inception project. 

## 1. Provided Services
This project runs multiple services together to create a fully working website environment:
- **WordPress:** The main website where you can publish posts and pages.
- **NGINX:** The web server that handles secure (HTTPS) connections and shows the website to visitors.
- **MariaDB:** The database that safely stores all the WordPress text, users, and settings.
- **Redis:** A caching system that makes the WordPress website load much faster.
- **FTP:** A file transfer service to easily upload or download website files.
- **Adminer:** A simple web interface to view and manage the database.
- **Static Website:** A simple, plain HTML website running on a small Python server.
- **Portainer:** A visual web interface to manage and monitor all the Docker containers.

## 2. How to Start and Stop the Project
To manage the project, open your terminal in the root folder of the repository:

- **To start the project:** Type `make up` or `make`. This will build and start all services in the background.
- **To stop the project:** Type `make down`. This will safely stop all running services.
- **To clear everything:** Type `make clean` or `make fclean` if you want to delete volume path. This will delete all build volumes.

## 3. How to Access the Websites
Once the project is running, you can access the different services using your web browser. Replace `<DOMAIN_NAME>` with your actual configured domain (e.g., `login.42.fr`).

- **Main WordPress Site:** `https://<DOMAIN_NAME>` (You may see a security warning because it uses a self-signed certificate. It is safe to click "Advanced" and "Proceed").
- **WordPress Admin Panel:** `https://<DOMAIN_NAME>/wp-admin`
- **Adminer (Database Manager):** `http://<DOMAIN_NAME>:8080`
- **Static Website:** `http://<DOMAIN_NAME>:4242`
- **Portainer (Docker Manager):** `http://<DOMAIN_NAME>:9000`

## 4. How to Locate and Manage Credentials
Your project configurations, usernames, and passwords are kept completely separate from the code for security. You can find and manage them in two places:

- **Environment Variables (.env file):** Located in the `srcs/` folder. This `.env` file contains your usernames, database names, emails, and your `DOMAIN_NAME` (e.g., `WP_ADMIN_USERNAME`).
- **Passwords (secrets/ directory):** Located in the `secrets/` folder at the root of the project. All passwords are saved in individual `.txt` files (e.g., `db_password.txt`, `wp_admin_password.txt`).

- **How to manage them:** The repository comes with template files for your safety. To configure your project:
    1. Rename the `srcs/.env.example` file to `.env` and edit your usernames, emails, and settings inside.
    2. Rename the `secrets_example/` folder to `secrets/` and replace the dummy passwords inside the respective `.txt` files.

## 5. How to Check if Services are Running
There are two easy ways to check the health of your services:
1. **Using Portainer:** Go to `http://<DOMAIN_NAME>:9000` in your browser. You can visually see all containers, check their status (running or stopped), and read their logs.
2. **Using the Terminal:** Open your terminal and run the command `docker ps`. This will print a list of all active containers and their current status.
