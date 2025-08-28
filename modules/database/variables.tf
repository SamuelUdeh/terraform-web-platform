variable "project" {}
variable "environment" {}
variable "subnets" { type = list(string) }
variable "vpc_id" {}
variable "db_name" {}
variable "db_username" {}
variable "db_password" { sensitive = true }
variable "db_instance_class" {}
variable "allocated_storage" { type = number }
variable "multi_az" { type = bool }
variable "app_sg_id" {}
