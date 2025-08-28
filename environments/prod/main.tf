terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.10.0"
    }
  }
}

provider "aws" {
  # Configuration options
}

# --- Networking ---
module "networking" {
  source               = "../../modules/networking"
  project              = var.project
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

# --- Database ---
module "database" {
  source              = "../../modules/database"
  project             = var.project
  environment         = var.environment
  subnets             = module.networking.private_subnet_ids
  vpc_id              = module.networking.vpc_id
  db_name             = var.db_name
  db_username         = var.db_username
  db_password         = var.db_password
  db_instance_class   = var.db_instance_class
  allocated_storage   = var.db_allocated_storage
  multi_az            = var.multi_az
  app_sg_id           = module.compute.app_sg_id  
}

# --- Compute ---
module "compute" {
  source                 = "../../modules/compute"
  project                = var.project
  environment            = var.environment
  vpc_id                 = module.networking.vpc_id
  public_subnet_ids      = module.networking.public_subnet_ids
  private_subnet_ids     = module.networking.private_subnet_ids
  instance_type          = var.instance_type
  desired_capacity       = var.desired_capacity
  min_size               = var.min_size
  max_size               = var.max_size
  cpu_scale_out_threshold= var.cpu_scale_out
  cpu_scale_in_threshold = var.cpu_scale_in

  user_data = <<-EOT
    #!/bin/bash
    apt-get update -y
    apt-get install -y nginx
    echo "Hello from ${var.environment} - ${var.project}" > /var/www/html/index.html
    systemctl enable nginx && systemctl start nginx
  EOT
}

# --- Monitoring ---
module "monitoring" {
  source        = "../../modules/monitoring"
  project       = var.project
  environment   = var.environment
  alb_arn       = module.compute.alb_arn
  asg_name      = module.compute.asg_name
  alert_email   = var.alert_email
}
