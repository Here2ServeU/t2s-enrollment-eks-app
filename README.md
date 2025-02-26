# T2S Enrollment Web Application Deployment on AWS EKS with CI/CD and Observability

---
The **T2S Enrollment Web Applicatio**n is a **fully automated cloud-native solution** designed to facilitate seamless user enrollment in training programs. This project leverages **AWS EKS (Elastic Kubernetes Service), Terraform for infrastructure as code, GitHub Actions, GitLab CI/CD, and Jenkins for automated deployments**, and **Datadog for monitoring and observability**.

By integrating **React (frontend), Node.js (backend), and Nginx (reverse proxy)**, the application provides a **highly available, scalable, and cost-efficient** solution that follows modern **DevOps best practices**. This system not only ensures a **smooth and secure enrollment process** but also empowers DevOps engineers and cloud professionals with hands-on experience in **orchestrating a complete infrastructure deployment pipeline**.

---
## Project Structure
```plaintext
t2s-enrollment-app/
│── terraform/
│   ├── modules/
│   │   ├── vpc/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   ├── outputs.tf
│   │   ├── eks/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   ├── outputs.tf
│   │   ├── s3-backend/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   ├── outputs.tf
│   │   ├── ecr/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   ├── outputs.tf
│   │   ├── cicd/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   ├── outputs.tf
│   ├── environments/
│   │   ├── dev/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   ├── terraform.tfvars
│   │   │   ├── backend.tf
│   │   ├── prod/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   ├── terraform.tfvars
│   │   │   ├── backend.tf
│
│── k8s/
│   ├── frontend.yaml
│   ├── backend.yaml
│   ├── nginx.yaml
│
│── frontend-react/
│   ├── Dockerfile
│   ├── .github/workflows/deploy.yml
│   ├── .gitlab-ci.yml
│   ├── Jenkinsfile
│
│── backend-nodejs/
│   ├── Dockerfile
│   ├── .github/workflows/deploy.yml
│   ├── .gitlab-ci.yml
│   ├── Jenkinsfile
│
│── nginx/
│   ├── nginx.conf
│
│── README.md
```

---

## Terraform Modules

### 1. S3 Backend Module (State File Storage)

#### Creating File: terraform/modules/s3-backend/main.tf
```hcl
resource "aws_s3_bucket" "terraform_state" {
  bucket = var.s3_bucket_name
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "Terraform State Bucket"
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
```

#### Creating File: terraform/modules/s3-backend/variables.tf
```hcl
variable "s3_bucket_name" {
  description = "S3 bucket name for Terraform state"
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name for state locking"
}
```

### 2. ECR Module (Store Docker Images)

#### Creating File: terraform/modules/ecr/main.tf
```hcl
resource "aws_ecr_repository" "frontend_repo" {
  name = var.frontend_repo
}

resource "aws_ecr_repository" "backend_repo" {
  name = var.backend_repo
}
```

#### File: terraform/modules/ecr/variables.tf
```hcl
variable "frontend_repo" {
  description = "Name of the ECR repository for the frontend"
}

variable "backend_repo" {
  description = "Name of the ECR repository for the backend"
}
```

### 3. CI/CD Module (IAM and Pipeline Configurations)

Creating File: terraform/modules/cicd/main.tf
```hcl
resource "aws_iam_role" "cicd_role" {
  name = "cicd-role"
  assume_role_policy = jsonencode({
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "codebuild.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}
```

---

## CI/CD Pipelines

### GitHub Actions

#### Creating File: .github/workflows/deploy.yml
```yml
name: Deploy to AWS EKS

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v2

      - name: Login to AWS ECR
        run: |
          aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com

      - name: Build and Push Docker Image
        run: |
          docker build -t t2s-frontend .
          docker tag t2s-frontend:latest <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/t2s-frontend:latest
          docker push <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/t2s-frontend:latest

      - name: Deploy to EKS
        run: |
          kubectl apply -f k8s/frontend.yaml
```

### Frontend (React) Kubernetes Deployment

#### Creating File: k8s/frontend.yaml
```hcl
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: frontend
        image: <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/t2s-frontend:latest
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: frontend-service
spec:
  selector:
    app: frontend
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: LoadBalancer
```

---

## Observability with Datadog
#### 1.	Enable Datadog Kubernetes Monitoring
```bash
helm install datadog-agent datadog/datadog --set datadog.apiKey=<DATADOG_API_KEY>
```

#### 2.	View logs and metrics in Datadog UI.

---

## Deployment Steps

### Step 1: Deploy Infrastructure with Terraform
```bash
cd terraform/environments/dev
terraform init
terraform apply -auto-approve
```

### Step 2: Deploy Kubernetes Resources
```bash
kubectl apply -f k8s/
```

### Step 3: Run CI/CD Pipeline
- For GitHub Actions, push a change to main.
- For GitLab, push to the repository.
- For Jenkins, trigger a build.

---

## Key Enhancements

✔ Modularized Terraform setup
✔ S3 backend for state file storage
✔ CI/CD pipelines for GitHub Actions, GitLab CI/CD, and Jenkins
✔ Docker images stored in AWS ECR
✔ EKS Deployment with Kubernetes manifests
✔ Datadog monitoring for observability 

---

## Use Cases

### 1. Automated Enrollment System for Training Programs
- The web application serves as **a self-service enrollment platform** where students can register for **DevOps, Cloud, and IT training programs**.
- The application securely stores user details and course preferences in the backend.

### 2. Infrastructure as Code (IaC) for Scalable Deployments
- By using **Terraform modules**, this project ensures **repeatable and scalable deployments**.
- The infrastructure includes **S3 for state storage, AWS EKS for container orchestration, and ECR for Docker image management**.

### 3. Continuous Deployment & CI/CD Pipelines
- The deployment process is fully automated using **GitHub Actions, GitLab CI/CD, and Jenkins**, allowing teams to **rapidly push updates without downtime**.
- Each pipeline **automatically builds, tests, and deploys the latest version of the application**.

### 4. Cloud-Native Observability and Monitoring with Datadog
- **Datadog Agent** is deployed in Kubernetes to monitor logs, metrics, and application health.
- The setup provides **real-time alerts for performance bottlenecks, security incidents, and potential system failures**.

### 5. High Availability and Load Balancing
- The system uses **AWS Load Balancer** and **Kubernetes Service Mesh** to distribute traffic across multiple application instances.
- Ensures **minimal downtime and maximum reliability** for users.

---

## Conclusion

This project showcases a **fully automated DevOps pipeline** that integrates **infrastructure provisioning, deployment automation, observability, and scalability** in a real-world cloud environment.

By implementing **AWS EKS, Terraform, CI/CD pipelines, Kubernetes, and Datadog monitoring**, the **T2S Enrollment Web Application** provides a **robust, high-performance, and cost-effective solution** for managing course enrollments.

This project is **an excellent use case for Cloud & DevOps Engineers**, providing hands-on experience in **modern cloud-native architectures, automation best practices, and infrastructure management**. Whether you’re an aspiring DevOps professional or a company looking to **enhance operational efficiency**, this architecture serves as a powerful blueprint for building and deploying **scalable web applications**. 

This setup automates the entire workflow from infrastructure provisioning to deployment and monitoring.
