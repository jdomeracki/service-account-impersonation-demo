# Service Account Impersonation Demo

> A supplementary demo project showcasing [GCP Service Account Impersonation](https://docs.cloud.google.com/iam/docs/service-account-impersonation) in action.

## 📚 Related Research

This project accompanies the following research and presentations:

- **Speaker Deck**: [Privilege Escalation via a Service Account Impersonation Chain](https://speakerdeck.com/jdomeracki/privilege-escalation-via-a-service-account-impersonation-chain?slide=31)
- **Blog Post**: [Let's Sign Our Own JWTs](https://jdsec.cloud/posts/2025-12-10-privilege-escalation-via-a-service-account-impersonation-chain/#lets-sign-our-own-jwts)

## 🚀 Usage

### Terraform Setup

This project uses Terraform to provision the necessary GCP resources. You can run Terraform in two ways:

#### Option 1: Command Line Variables

Set the required variables directly when running Terraform commands:

```bash
terraform init
terraform plan \
  -var="project_id=your-project-id" \
  -var="user_email=your-email@example.com"
terraform apply \
  -var="project_id=your-project-id" \
  -var="user_email=your-email@example.com"
```

#### Option 2: Terraform Variables File

Create a `terraform.tfvars` file in the project root:

```hcl
project_id = "your-project-id"
user_email = "your-email@example.com"
region     = "us-central1"  # optional
```

Then run Terraform without specifying variables:

```bash
terraform init
terraform plan
terraform apply
```

### JWT Signing Script

Run the JWT signing script with your project ID:

```bash
PROJECT_ID=your-project-id ./sing_jwt.sh
```

## 📋 Prerequisites

- [Terraform](https://www.terraform.io/downloads) installed
- GCP project with appropriate permissions
- `gcloud` CLI configured with authentication
