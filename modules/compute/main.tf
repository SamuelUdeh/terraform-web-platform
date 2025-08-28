# Security groups
resource "aws_security_group" "alb" {
  name   = "${var.project}-${var.environment}-alb-sg"
  vpc_id = var.vpc_id
  ingress { 
    from_port=80 
    to_port=80 
    protocol="tcp" 
    cidr_blocks=["0.0.0.0/0"] 
    }
  egress  { 
    from_port=0 
    to_port=0 
    protocol="-1" 
    cidr_blocks=["0.0.0.0/0"] 
    }
}

resource "aws_security_group" "app" {
  name   = "${var.project}-${var.environment}-app-sg"
  vpc_id = var.vpc_id
  ingress { 
    from_port=80 
    to_port=80 
    protocol="tcp" 
    security_groups=[aws_security_group.alb.id] 
    }
  egress  { 
    from_port=0 
    to_port=0 
    protocol="-1" 
    cidr_blocks=["0.0.0.0/0"] 
    }
}

# ALB
resource "aws_lb" "this" {
  name               = "${var.project}-${var.environment}-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public_subnet_ids
}

resource "aws_lb_target_group" "tg" {
  name     = "${var.project}-${var.environment}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check { 
    path = "/" 
    healthy_threshold = 2 
    unhealthy_threshold = 2 
    }


}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port = 80
  protocol = "HTTP"
  default_action {
     type = "forward" 
     target_group_arn = aws_lb_target_group.tg.arn 
     }
}

# Launch template
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] 
  filter { 
    name = "name" 
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"] 
    }
}

resource "aws_launch_template" "lt" {
  name_prefix   = "${var.project}-${var.environment}-lt-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  user_data     = base64encode(var.user_data)
  network_interfaces {
    security_groups = [aws_security_group.app.id]
  }
}

# ASG
resource "aws_autoscaling_group" "asg" {
  name                = "${var.project}-${var.environment}-asg"
  desired_capacity    = var.desired_capacity
  min_size            = var.min_size
  max_size            = var.max_size
  vpc_zone_identifier = var.private_subnet_ids

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.tg.arn]
  health_check_type = "EC2"

  lifecycle { create_before_destroy = true }
}

# Scaling policies (CPU via CloudWatch)
resource "aws_cloudwatch_metric_alarm" "scale_out" {
  alarm_name          = "${var.project}-${var.environment}-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = var.cpu_scale_out_threshold
  dimensions = { AutoScalingGroupName = aws_autoscaling_group.asg.name }
  alarm_actions = [aws_autoscaling_policy.scale_out.arn]
}

resource "aws_cloudwatch_metric_alarm" "scale_in" {
  alarm_name          = "${var.project}-${var.environment}-cpu-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = var.cpu_scale_in_threshold
  dimensions = { AutoScalingGroupName = aws_autoscaling_group.asg.name }
  alarm_actions = [aws_autoscaling_policy.scale_in.arn]
}

resource "aws_autoscaling_policy" "scale_out" {
  name                   = "${var.project}-${var.environment}-scale-out"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "${var.project}-${var.environment}-scale-in"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

output "alb_dns_name" { value = aws_lb.this.dns_name }
output "alb_arn"      { value = aws_lb.this.arn }
output "asg_name"     { value = aws_autoscaling_group.asg.name }
output "app_sg_id"    { value = aws_security_group.app.id }
