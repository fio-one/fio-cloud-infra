#!/bin/bash
              
# Update and install Tools and Packages
sudo apt-get update
sudo apt-get install -y docker.io docker-compose awscli mysql-client

# Add ubuntu user to docker group
sudo usermod -aG docker ubuntu

# Create app directory structure
sudo mkdir -p /home/ubuntu/app/nginx/{conf.d,ssl}
sudo chown -R ubuntu:ubuntu /home/ubuntu/app

# Generate self-signed SSL certificate
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /home/ubuntu/app/nginx/ssl/nginx.key \
  -out /home/ubuntu/app/nginx/ssl/nginx.crt \
  -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"

# Create Nginx config
cat > /home/ubuntu/app/nginx/conf.d/default.conf << 'NGINX'
server {
    listen 80;
    server_name localhost;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name localhost;

    ssl_certificate /etc/nginx/ssl/nginx.crt;
    ssl_certificate_key /etc/nginx/ssl/nginx.key;

    location / {
        proxy_pass http://frontend:80;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location /api {
        proxy_pass http://backend:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
NGINX

# Create docker-compose.yml
cat > /home/ubuntu/app/docker-compose.yml << 'DOCKER'
version: '3.8'
services:
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/conf.d:/etc/nginx/conf.d
      - ./nginx/ssl:/etc/nginx/ssl
    depends_on:
      - frontend
      - backend

  frontend:
    image: ${frontend_repo}:latest
    environment:
      - API_URL=/api

  backend:
    image: ${backend_repo}:latest
    environment:
      - APP_ENV=fio-app
DOCKER