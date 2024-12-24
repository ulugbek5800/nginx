# Nginx Reverse Proxy with Docker Compose

## Overview
This project demonstrates the use of **Nginx** as a reverse proxy to load balance requests across multiple Node.js backend services. It uses **Docker Compose** to create and manage the containers. Also it includes **SSL/TLS support** with a self-signed certificate and HTTP to HTTPS redirection.

## Features
- **Reverse Proxy**: Nginx listens on port 443 (HTTPS) and port 8080 (HTTP with redirect) routes traffic to three Node.js backend services.
- **Load Balancing**: Traffic is distributed to the upstream block using the `least_conn` algorithm.
- **SSL/TLS Encryption**: Secures traffic with a self-signed SSL certificate.
- **HTTP to HTTPS Redirect**: Requests to HTTP are redirected to HTTPS.
- **Dockerized Backend Services**: Backend services are containerized with Docker Compose.

## Prerequisites
- **Docker** and **Docker Compose** installed
- **Nginx** installed on your local machine
- Self-signed **SSL certificates** created and stored at:
    - `/etc/nginx/certs/nginx-selfsigned.crt`
    - `/etc/nginx/certs/nginx-selfsigned.key`

## How to Run
1. **Clone the repository**:
    ```bash
    git clone https://github.com/ulugbek5800/nginx-with-docker.git
    cd nginx-with-docker
    ```
2. **Configure Nginx**:
    - Update the Nginx configuration file (`/etc/nginx/nginx.conf` on host machine):
    ```nginx
    worker_processes 1;

    events {
        worker_connections 1024;
    }

    http {
        include mime.types;

        upstream nodejs_servers {
            least_conn;
            server 127.0.0.1:3001;
            server 127.0.0.1:3002;
            server 127.0.0.1:3003;
        }

        server {
            listen 443 ssl;
            server_name localhost;

            ssl_certificate /etc/nginx/certs/nginx-selfsigned.crt;
            ssl_certificate_key /etc/nginx/certs/nginx-selfsigned.key;

            location / {
                proxy_pass http://nodejs_servers;
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
            }
        }

        server {
            listen 8080;
            server_name localhost;

            location / {
                return 301 https://$host$request_uri;
            }
        }
    }
    ```
    - Restart Nginx:
    ```
    sudo systemctl restart nginx
    ```
3. **Build and run the containers**:
    ```
    docker-compose up --build -d
    ```
    - The `docker-compose.yml` file defines three backend services (`app1`, `app2`, `app3`), each mapped to host ports `3001`, `3002`, and `3003`.
4. **Access the application**:
    - Via HTTPS: `https://localhost`.
    - For testing:
        - HTTP redirection: `http://localhost:8080`
        - Backend services directly: `http://localhost:3001`, `http://localhost:3002`, `http://localhost:3003`
5. **Stop the containers and services**:
    ```
    docker-compose down
    sudo systemctl stop nginx
    ```

## Notes
- **SSL/TLS**: Browsers will display a security warning due to the self-signed certificate. This is fine for development and learning purposes.
- **Reference Configuration**: The `nginx.conf` file in the `config` folder is a reference copy. Update the actual configuration at `/etc/nginx/nginx.conf`.
- **Static Files**: The static folder contains HTML and CSS files served by the Node.js backend.
- **Logs**: Use `docker-compose logs` for backend logs, and `sudo tail -f /var/log/nginx/access.log /var/log/nginx/error.log` for Nginx logs.
- **Worker Processes**: In configuration, set `worker_processes auto` (equal to the number of CPU cores) to take advantage of parallel processing.