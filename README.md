# Multi-Environment AWS Infrastructure with ALB, ASG, RDS & Monitoring Using Terraform

Production-ready, auto-scaling web platform on AWS using Terraform modules and separate environments (dev, prod). Includes ALB, ASG (EC2 with Nginx via user_data), RDS (MySQL), and CloudWatch monitoring.

🔧 **Features**

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



