variable "project" {}
variable "environment" {}
variable "vpc_id" {}
variable "public_subnet_ids" { type = list(string) }
variable "private_subnet_ids" { type = list(string) }
variable "instance_type" {}
variable "desired_capacity" { type = number }
variable "min_size" { type = number }
variable "max_size" { type = number }
variable "cpu_scale_out_threshold" { type = number }
variable "cpu_scale_in_threshold" { type = number }
variable "user_data" { type = string }
