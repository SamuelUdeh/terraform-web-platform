# Multi-Environment AWS Infrastructure With ALB, ASG, RDS & Monitoring Using Terraform

Production-ready, auto-scaling web platform on AWS using Terraform modules and separate environments (dev, prod). Includes ALB, ASG (EC2 with Nginx via user_data), RDS (MySQL), and CloudWatch monitoring.

 **Features**

- Modular Terraform (networking, compute, database, monitoring)

- ALB + Target Groups + health checks

- ASG with CPU-based scaling policies

- RDS MySQL (multi-AZ ready) with automated backups

- CloudWatch metrics/alarms (EC2, ALB, RDS)

- Isolated dev and prod configurations


**Project Structure**

```
terraform-web-platform/
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── terraform.tfvars         
│   │                 
│   └── prod/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── terraform.tfvars
│       
├── modules/
│   ├── networking/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── compute/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── database/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── monitoring/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf                  
├── README.md
└── .gitignore
```

**Module Roles**

- **Networking:** VPC, subnets (public/private AZ1/AZ2), IGW, NAT, routes, SGs

- **Compute:** ALB, target group, listener, launch template (Nginx user_data), ASG, scaling policies

- **Database**: RDS MySQL, subnet group, parameter group, backups

- **Monitoring**: CloudWatch alarms/dashboards (CPU, HTTP 5xx, latency, RDS health)

# Quick Start

# From repo root
# Work in the dev environment

```
cd environments/dev
terraform init
terraform plan 
terraform apply 
```

# Work in the prod environment
# From repo root

```
cd environments/prod
terraform init
terraform plan 
terraform apply 
```

![Terraform Project 2](https://github.com/user-attachments/assets/a0ec1e4b-49ae-4b0c-b736-a1b3a9b15024)


Outputs will include the **ALB DNS** (accessible via browser) and the **RDS** endpoint.

**Verification & Tests**

- **ALB/EC2:** curl http://<alb_dns> → should return the Nginx page with env banner.

- **Health checks:** Target group → targets = healthy.

- **Scaling:** Generate CPU load on an instance (e.g., stress-ng) or adjust policy thresholds; watch ASG scale events.

- **RDS:** Connect with a MySQL client to the RDS endpoint using credentials from terraform.tfvars.

- **Monitoring:** CloudWatch → check EC2/ALB/RDS metrics; confirm alarms trigger and recover.

**Security**

- Keep secrets only in terraform.tfvars (git-ignored).

- App SG allows inbound only from ALB SG.

- RDS not publicly accessible; only from app SG.


# Destroy The Resources
```
cd environments/dev
terraform destroy
```

![Terraform Project 2b](https://github.com/user-attachments/assets/152ab4aa-b6b8-455c-8b3e-8fbfc0d8cb91)








