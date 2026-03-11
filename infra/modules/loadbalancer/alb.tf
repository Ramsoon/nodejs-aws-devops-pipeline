resource "aws_lb" "app_lb" {

  name               = "devops-alb"
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = [var.security_group_id]
}

# determine whether we have a certificate arn for https
locals {
  has_cert = var.certificate_arn != null && var.certificate_arn != ""
}

resource "aws_lb_target_group" "tg" {

  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = "/health"
  }
}

resource "aws_lb_target_group_attachment" "tg_attach" {

  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = var.instance_id
  port             = 3000
}

resource "aws_lb_listener" "http" {
  count              = local.has_cert ? 1 : 0
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_lb_listener" "https" {
  count              = local.has_cert ? 1 : 0
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
