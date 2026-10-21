# 🚀 End-to-End DevOps Platform

An end-to-end DevOps project demonstrating application development, automated CI, code quality checks, Docker image publishing, and Kubernetes deployment.

The project uses **Jenkins, Docker, Docker Hub, Kubernetes (kind), Python, Flask, Ruff, and pytest** to implement a practical CI/CD workflow.

## 📌 Project Overview

This project demonstrates how to build, test, containerize, and deploy a Python web application using commonly used DevOps tools.

The application exposes a home endpoint and a health-check endpoint. Jenkins automates code validation, testing, Docker image creation, and publishing to Docker Hub. The published image can then be deployed to a local Kubernetes cluster.

### Key Features

- Automated CI pipeline using Jenkins
- Python syntax validation and code quality checks using Ruff
- Automated application tests using pytest
- Docker image creation and version tagging
- Docker Hub image publishing
- Kubernetes deployment with two replicas
- Readiness and liveness probes
- Resource requests and limits for application containers
- Health-check endpoint for application verification
- Deployment script with Kubernetes context validation

## 🏗️ Architecture

```text
              Developer
                  |
                  v
             GitHub Repo
                  |
                  v
             Jenkins CI
                  |
          +-------+--------+
          |       |        |
          v       v        v
       Syntax   Ruff     pytest
       Check   Linting   Tests
                  |
                  v
          Build Docker Image
                  |
                  v
             Docker Hub
                  |
                  v
        Deployment Script
           (Local Mac)
                  |
                  v
        Kubernetes (kind)
             /       \
            v         v
        Replica 1   Replica 2
            \         /
             v       v
          Flask Application
                  |
                  v
           Health Endpoint
```

**Deployment model:** Jenkins runs on an AWS EC2 instance, while the local Kubernetes cluster runs on a Mac using kind. Image publishing is automated in Jenkins; Kubernetes deployment is initiated separately using the local deployment script.

## 🛠️ Technology Stack

| Technology | Purpose |
|---|---|
| Python | Application development |
| Flask | Web application framework |
| Git & GitHub | Source code management |
| Jenkins | CI pipeline automation |
| Ruff | Code quality and linting |
| pytest | Automated testing |
| Docker | Application containerization |
| Docker Hub | Container image registry |
| Kubernetes | Container orchestration |
| kind | Local Kubernetes cluster |
| Helm | Kubernetes package management |

## 📂 Project Structure

```text
devops-platform/
├── app.py
├── requirements.txt
├── requirements-dev.txt
├── Dockerfile
├── Jenkinsfile
├── tests/
│   └── app_test.py
├── kubernetes/
│   ├── deployment.yaml
│   └── service.yaml
└── scripts/
    └── deploy.sh
```

## ⚙️ Application Endpoints

The Flask application exposes the following endpoints:

| Endpoint | Description |
|---|---|
| `/` | Returns application information and status |
| `/health` | Returns application health and a UTC timestamp |

Example health response:

```json
{
  "status": "Healthy",
  "timestamp": "2026-10-21T14:57:18.604554+00:00"
}
```

The timestamp is illustrative; the application generates a fresh timestamp for each health request.

## 🔄 Jenkins CI Pipeline

The Jenkins pipeline includes the following stages:

1. **Checkout** — retrieves source code from GitHub.
2. **Python Syntax Validation** — checks Python source syntax.
3. **Code Quality** — runs Ruff to identify linting issues.
4. **Automated Tests** — executes pytest test cases.
5. **Docker Build** — creates a container image tagged with the Jenkins build number and `latest`.
6. **Container Smoke Test** — starts the container and verifies the `/health` endpoint.
7. **Publish Image** — authenticates with Docker Hub using Jenkins credentials and publishes the image.

### Example image tags

```text
dineshk26/devops-platform:3
dineshk26/devops-platform:latest
```

Versioned tags make it possible to identify and deploy a specific Jenkins build.

## 🐳 Run the Application Locally

Clone the repository:

```bash
git clone https://github.com/DineshKarthick26/devops-platform.git
cd devops-platform
```

Create and activate a Python virtual environment:

```bash
python3 -m venv .venv
source .venv/bin/activate
```

Install application dependencies:

```bash
pip install -r requirements.txt
```

Start the application:

```bash
python app.py
```

Open the application at:

- Home: http://localhost:5001/
- Health: http://localhost:5001/health

## 🧪 Run Tests and Code Quality Checks

Install development dependencies:

```bash
pip install -r requirements-dev.txt
```

Run automated tests:

```bash
python -m pytest -v
```

Run Ruff:

```bash
ruff check --target-version=py39 app.py tests
```

## 🐋 Build and Run with Docker

Build the image:

```bash
docker build -t devops-platform:v1 .
```

Run the container:

```bash
docker run --rm -p 5001:5001 devops-platform:v1
```

Verify the health endpoint:

```bash
curl http://localhost:5001/health
```

## ☸️ Kubernetes Deployment

The application is deployed to a local Kubernetes cluster created using kind.

The Kubernetes configuration includes:

- Two application replicas
- A ClusterIP Service
- Readiness and liveness probes
- CPU and memory requests and limits

### Verify the cluster

```bash
kubectl config current-context
kubectl get nodes
```

### Apply the Kubernetes manifests

```bash
kubectl apply -f kubernetes/deployment.yaml
kubectl apply -f kubernetes/service.yaml
```

Check the deployment and pods:

```bash
kubectl get deployments
kubectl get pods -l app=devops-platform
kubectl get services
```

### Deploy a specific Jenkins build

After Jenkins successfully publishes an image, deploy its build number using the local script.

For example:

```bash
chmod +x scripts/deploy.sh
./scripts/deploy.sh 3
```

Replace `3` with the Jenkins build number you want to deploy.

The script checks the current Kubernetes context, updates the deployment image, waits for the rollout, and displays the application pods. It refuses to deploy if the current context does not start with `kind-`.

### Verify the deployed application

```bash
kubectl rollout status deployment/devops-platform
kubectl get deployment devops-platform
kubectl get pods -l app=devops-platform
```

Access the application through port forwarding:

```bash
kubectl port-forward service/devops-platform 8081:80
```

In another terminal, run:

```bash
curl http://localhost:8081/
curl http://localhost:8081/health
```

## 🔐 Security Practices

- Docker Hub credentials are stored in Jenkins Credentials rather than hardcoded in the pipeline.
- Versioned Docker image tags identify individual builds.
- The deployment script checks the Kubernetes context before changing the deployment.
- Kubernetes readiness and liveness probes help detect application health issues.
- Jenkins access should be restricted to authorized users, and its EC2 security group should allow access only from trusted IP addresses.

## 📚 What I Learned

Through this project, I practised:

- Designing a multi-stage Jenkins CI pipeline
- Integrating GitHub with Jenkins
- Automating linting and unit tests
- Building and publishing Docker images
- Deploying containerized applications to Kubernetes
- Configuring Kubernetes Deployments, Services, and health probes
- Managing image versions and deployment rollouts
- Troubleshooting container startup and Kubernetes deployment issues

## 🚀 Future Improvements

- Trigger builds automatically on GitHub pushes using a secure webhook
- Add automated rollback procedures for failed deployments
- Add Helm-based application deployment
- Introduce Kubernetes secrets and configuration management
- Add monitoring and observability when sufficient local resources are available
- Add a secure, automated deployment mechanism between Jenkins and Kubernetes

## 👨‍💻 Author

**Dinesh Karthick**

Network Security Engineer | Aspiring DevOps & Cloud Engineer

- GitHub: [DineshKarthick26](https://github.com/DineshKarthick26)

---

*This project is built for hands-on learning and demonstrating practical DevOps engineering skills.*
