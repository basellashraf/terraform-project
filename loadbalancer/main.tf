######################################
# Public Application Load Balancer
######################################
resource "aws_lb" "public_lb" {
  name               = var.public_lb_name
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = [var.public_lb_sg]
  ip_address_type    = "ipv4"

  tags = {
    Name = var.public_lb_name
  }
}

# Target Group for Public LB
resource "aws_lb_target_group" "public_tg" {
  name        = var.public_tg_name
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = var.public_tg_name
  }
}

# Listener for Public LB
resource "aws_lb_listener" "public_listener" {
  load_balancer_arn = aws_lb.public_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.public_tg.arn
  }

  tags = {
    Name = "${var.public_lb_name}-listener"
  }
}


######################################
# Private Application Load Balancer
######################################
resource "aws_lb" "private_lb" {
  name               = var.private_lb_name
  load_balancer_type = "application"
  subnets            = var.private_subnets
  security_groups    = [var.private_lb_sg]
  internal           = true              
  ip_address_type    = "ipv4"

  tags = {
    Name = var.private_lb_name
  }
}

# Target Group for Private LB
resource "aws_lb_target_group" "private_tg" {
  name        = var.private_tg_name
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = var.private_tg_name
  }
}

# Listener 
resource "aws_lb_listener" "private_listener" {
  load_balancer_arn = aws_lb.private_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.private_tg.arn
  }

  tags = {
    Name = "${var.private_lb_name}-listener"
  }
}

######################################
# Attach Instances to Target Groups
######################################
# Public TG Attachments 
resource "aws_lb_target_group_attachment" "public_tg_attachments" {
  count               = length(var.public_target_instance_ids)
  target_group_arn    = aws_lb_target_group.public_tg.arn
  target_id           = var.public_target_instance_ids[count.index]
  port                = 80
}

# Private TG Attachments 
resource "aws_lb_target_group_attachment" "private_tg_attachments" {
  count               = length(var.private_target_instance_ids)
  target_group_arn    = aws_lb_target_group.private_tg.arn
  target_id           = var.private_target_instance_ids[count.index]
  port                = 80
}
