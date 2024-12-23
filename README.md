# Nginx Reverse Proxy with Docker Compose

## Description
This project demonstrates the use of **Nginx** as a reverse proxy to load balance the requests across three Node.js backend services. It uses **Docker Compose** to create and manage three backend containers.

## Features
- **Reverse Proxy**: Nginx listens on port `8080` and routes traffic to three backend Node.js servers.
- **Load Balancing**: Nginx distributes traffic to the upstream block configured with `least_conn` algorithm.
- **Dockerization**: Backend services are containerized using Docker containers and Docker Compose.

## Prerequisites
- **Docker** and **Docker Compose** installed
- **Nginx** installed on your local machine

## How to Run
1. **Clone the repository**:
    ```bash
    git clone https://github.com/ulugbek5800/nginx-with-docker.git
    cd nginx-with-docker
    ```
2. **Configure Nginx**:
    - Edit `/etc/nginx/nginx.conf`:
    ```nginx
    worker_processes auto;

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
            listen 8080;
            server_name localhost;

            location / {
                proxy_pass http://nodejs_servers;
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
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
4. **Access the application**:
    - Nginx reverse proxy: http://localhost:8080
    - You can verify direct backend services: http://localhost:3001, http://localhost:3001, http://localhost:3001
5. **Stop the containers**:
    ```
    docker-compose down
    ```

## Notes
- **Load Balancing**: The `least_conn` directive in `nginx.conf` ensures traffic is routed to the backend server with the least active connections.
- **Static Files**: The frontend folder contains static HTML and CSS files served by the Node.js backend.
- **Logs**: Use `docker logs <container_id>` or `docker-compose logs` to view logs from the backend services.