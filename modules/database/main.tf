# DB SG allows only app SG
resource "aws_security_group" "db" {
  name   = "${var.project}-${var.environment}-db-sg"
  vpc_id = var.vpc_id
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.app_sg_id]
  }
  egress { 
    from_port=0 
    to_port=0 
    protocol="-1" 
    cidr_blocks=["0.0.0.0/0"] 
    }
}

resource "aws_db_subnet_group" "db_subnets" {
  name       = "${var.project}-${var.environment}-db-subnets"
  subnet_ids = var.subnets
}

resource "aws_db_instance" "mysql" {
  identifier              = "${var.project}-${var.environment}-mysql"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = var.db_instance_class
  username                = var.db_username
  password                = var.db_password
  db_name                 = var.db_name
  db_subnet_group_name    = aws_db_subnet_group.db_subnets.name
  vpc_security_group_ids  = [aws_security_group.db.id]
  allocated_storage       = var.allocated_storage
  storage_encrypted       = true
  multi_az                = var.multi_az
  publicly_accessible     = false
  backup_retention_period = 7
  skip_final_snapshot     = true
}

output "db_endpoint" { value = aws_db_instance.mysql.address }
