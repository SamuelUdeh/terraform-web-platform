**Multi-Environment AWS Infrastructure with ALB, ASG, RDS & Monitoring Using Terraform** 

Production-ready, auto-scaling web platform on AWS using Terraform modules and separate environments (dev, prod). Includes ALB, ASG (EC2 with Nginx via user_data), RDS (MySQL), and CloudWatch monitoring.

🔧 **Features**

- Modular Terraform (networking, compute, database, monitoring)

- ALB + Target Groups + health checks

- ASG with CPU-based scaling policies

- RDS MySQL (multi-AZ ready) with automated backups

- CloudWatch metrics/alarms (EC2, ALB, RDS)

- Isolated dev and prod configurations


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

