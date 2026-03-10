# CredPal DevOps Assessment Project

## Overview

This project demonstrates a **production-ready DevOps pipeline** for deploying a simple Node.js web application using modern DevOps practices.

The application exposes three endpoints:

* `GET /health`
* `GET /status`
* `POST /process`

The system is fully containerized and deployed to AWS with automated CI/CD.

The stack includes:

* Node.js
* Redis
* Docker
* Docker Compose
* GitHub Actions
* Terraform
* AWS EC2 + ALB

---

# Architecture

```
User
  |
  v
AWS Application Load Balancer
  |
  v
EC2 Instance
  |
  v
Docker Compose
   ├── Node.js Application
   └── Redis
```

Infrastructure is provisioned using Terraform and the application is deployed automatically through GitHub Actions.

---

# Project Structure

```
.
├── app/
│   ├── server.js
│   ├── Dockerfile
│   ├── docker-compose.yml
│   └── bootstrap.sh
│
├── infra/
│   ├── main.tf
│   ├── outputs.tf
│   └── modules/
│
├── .github/
│   └── workflows/
│       └── cicd.yml
│
├── .env.example
└── README.md
```

---

# Application Endpoints

## Health Check

```
GET /health
```

Response:

```
{
  "status": "healthy"
}
```

---

## Service Status

```
GET /status
```

Response:

```
{
  "app": "running",
  "redis": "connected"
}
```

---

## Process Data

```
POST /process
```

Example Request:

```
POST /process
Content-Type: application/json

{
  "data": "sample-data"
}
```

Response:

```
{
  "message": "Data processed successfully"
}
```

The endpoint stores the submitted data in Redis.

---

# Running the Application Locally

## Requirements

Install:

* Docker
* Docker Compose
* Node.js (optional if running without containers)

---

## Clone the Repository

```
git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git
cd YOUR_REPO/app
```

---

## Create Environment File

Create a `.env` file:

```
PORT=3000
NODE_ENV=development
REDIS_HOST=redis
REDIS_PORT=6379
JWT_SECRET=local_secret
DOCKERHUB_USERNAME=yourdockerhubusername
```

---

## Start the Application

Run:

```
docker compose up
```

This starts:

* Node.js application
* Redis database

---

# Accessing the Application

Once running locally:

Health endpoint:

```
http://localhost:3000/health
```

Status endpoint:

```
http://localhost:3000/status
```

Example process request:

```
curl -X POST http://localhost:3000/process \
-H "Content-Type: application/json" \
-d '{"data":"hello"}'
```

---

# Deployment

Deployment is automated through **GitHub Actions CI/CD pipeline**.

## Deployment Steps

1. Push code to the repository
2. GitHub Actions pipeline starts
3. Docker image is built
4. Image is pushed to DockerHub
5. Terraform provisions infrastructure on AWS
6. EC2 instance installs required dependencies using a bootstrap script
7. Docker Compose pulls the latest image and starts the application

---

# CI/CD Pipeline

CI/CD is implemented using **GitHub Actions**.

Pipeline stages:

1. Build Docker Image
2. Push Image to DockerHub
3. Terraform Infrastructure Provisioning
4. Manual Approval (Production)
5. Application Deployment via SSH
6. Docker Compose startup

The workflow can be manually triggered with options:

```
apply
destroy
```

This allows controlled infrastructure lifecycle management.

---

# Infrastructure as Code

Infrastructure is provisioned using **Terraform**.

The infrastructure includes:

* VPC
* Public Subnets
* Security Groups
* EC2 Instance
* Application Load Balancer
* HTTPS support via ACM (optional)

Terraform modules are used to improve maintainability and reusability.

---

# Security Decisions

Several security best practices were implemented:

### Non-root Docker container

The application runs as a non-root user inside the container to minimize risk.

### Secrets management

Sensitive data is stored in GitHub Secrets, including:

* AWS credentials
* DockerHub credentials
* Application environment variables

The `.env` file is dynamically generated during deployment from GitHub Secrets.

### Environment isolation

Configuration values are externalized through environment variables rather than hardcoded in the application.

### Container health checks

Docker health checks ensure that unhealthy containers are detected automatically.

---

# Observability

Basic observability is implemented through:

* Application logging via console logs
* Docker container health checks
* `/health` endpoint for service monitoring

These allow integration with load balancers and monitoring tools.

---

# Key DevOps Design Decisions

### Containerized Architecture

Docker ensures consistent environments across development, testing, and production.

### Infrastructure as Code

Terraform ensures infrastructure is reproducible, version controlled, and automated.

### Automated CI/CD

GitHub Actions provides automated build, test, and deployment pipelines.

### Immutable Deployments

Each deployment pulls a fresh Docker image from DockerHub rather than rebuilding on the server.

### Modular Terraform Design

Terraform modules improve scalability and maintainability of infrastructure code.

---

# Future Improvements

Possible enhancements include:

* Adding automated tests in CI
* Implementing blue/green deployments
* Adding monitoring with Prometheus and Grafana
* Using AWS Secrets Manager instead of GitHub Secrets
* Adding centralized logging

---

# Conclusion

This project demonstrates a complete DevOps workflow including:

* Containerization
* Infrastructure automation
* CI/CD pipeline
* Secure configuration management
* Cloud deployment

The architecture is designed to be scalable, maintainable, and production-ready.
