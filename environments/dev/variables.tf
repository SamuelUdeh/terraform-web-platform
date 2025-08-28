variable "project" {}
variable "environment" {}
variable "aws_region" {}

variable "vpc_cidr" {}
variable "public_subnet_cidrs" { type = list(string) }
variable "private_subnet_cidrs" { type = list(string) }

variable "instance_type" {}
variable "desired_capacity" { type = number }
variable "min_size" { type = number }
variable "max_size" { type = number }
variable "cpu_scale_out" { type = number }
variable "cpu_scale_in" { type = number }

variable "db_name" {}
variable "db_username" {}
variable "db_password" { sensitive = true }
variable "db_instance_class" {}
variable "db_allocated_storage" { type = number }
variable "multi_az" { type = bool }

variable "alert_email" {}
