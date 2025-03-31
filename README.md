# T2S Enrollment Web Application – AWS EKS Infrastructure Deployment

This project sets up a **production-grade, fully automated infrastructure** for the T2S Enrollment Web Application using:

- **AWS EKS** for Kubernetes
- **Terraform** modules for Infrastructure as Code
- **GitHub Actions / GitLab CI / Jenkins** for CI/CD
- **Datadog** for observability
- **WAF, IAM, and HPA** for security and resilience

---

## 📁 Project Structure

```plaintext
t2s-enrollment-app/
│── terraform/
│   ├── modules/
│   │   ├── vpc/
│   │   ├── eks/
│   │   ├── s3-backend/
│   │   ├── ecr/
│   │   ├── cicd/
│   │   ├── security/
│   │   ├── monitoring/
│   │   ├── resilience/
│   ├── environments/
│   │   ├── dev/
│   │   ├── prod/
│
│── k8s/
│   ├── frontend.yaml
│   ├── backend.yaml
│   ├── nginx.yaml
│
│── frontend-react/
│   ├── Dockerfile
│   ├── .github/workflows/deploy.yml
│
│── backend-nodejs/
│   ├── Dockerfile
│   ├── .github/workflows/deploy.yml
```

---

## Terraform Module Responsibilities

| Module        | Description                                       |
|---------------|---------------------------------------------------|
| `vpc`         | Creates VPC and subnets                           |
| `eks`         | Provisions EKS cluster                            |
| `s3-backend`  | Manages Terraform backend (S3 + DynamoDB)         |
| `ecr`         | Creates frontend/backend Docker registries        |
| `cicd`        | Sets up IAM roles for CI/CD tools                 |
| `security`    | Configures WAF and IAM roles                      |
| `monitoring`  | Deploys Datadog agent using Helm                  |
| `resilience`  | Adds HPA for frontend and backend apps            |

---

## How to Deploy

### Step 1: Configure Remote Backend

Update `backend.tf` in `terraform/environments/dev/`:

```hcl
terraform {
  backend "s3" {
    bucket         = "t2s-enrollment-tf-state"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "t2s-enrollment-tf-lock"
  }
}
```

---

### Step 2: Initialize & Apply Terraform

```bash
cd terraform/environments/dev
terraform init
terraform apply -auto-approve
```

---

### Step 3: Deploy Kubernetes Resources

```bash
kubectl apply -f k8s/
```

---

### Step 4: Setup CI/CD

#### GitHub Actions (Example in `frontend-react/.github/workflows/deploy.yml`)
```yaml
on:
  push:
    branches: [main]
jobs:
  build-deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Build, Push, and Deploy
        run: |
          aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com
          docker build -t t2s-frontend .
          docker tag t2s-frontend:latest <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/t2s-frontend:latest
          docker push <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/t2s-frontend:latest
          kubectl apply -f k8s/frontend.yaml
```

---

### Step 5: Enable Datadog Monitoring

```bash
helm repo add datadog https://helm.datadoghq.com
helm install datadog-agent datadog/datadog \
  --set datadog.apiKey=<DATADOG_API_KEY> \
  --set datadog.site="datadoghq.com" \
  --set agents.containerLogs.enabled=true
```

---

## Verification Checklist

### Kubernetes
```bash
kubectl get nodes
kubectl get pods -n t2s-enrollment
kubectl get svc -n t2s-enrollment
```

### Application
```plaintext
http://<LoadBalancer-EXTERNAL-IP>
https://t2s-enroll.com  # If Route53 domain is configured
```

### Logs and Monitoring
```bash
kubectl logs <pod-name> -n t2s-enrollment
```
> Use Datadog dashboard for live metrics, alerts, and dashboards.

---

## Security & Resilience

- IAM roles for secure access to EKS
- WAF to protect APIs and web interface
- HPA auto-scales frontend and backend deployments

---

## Use Cases

- Secure online course enrollment system
- Modern DevOps practice showcase with IaC + CI/CD + Monitoring
- Training environment for DevOps and Cloud Engineers

---

## Requirements

- Terraform v1.3+
- AWS CLI configured
- kubectl installed
- Datadog API Key (for monitoring)
- Docker installed

---

## Tip

To destroy the infrastructure:
```bash
terraform destroy -auto-approve
```

---

## Contributing

Just to let you know, pull requests are welcome. Open an issue first for significant changes to discuss what you’d like to change.

---

## License

[MIT](LICENSE)
