resource "aws_lb" "alb" {
  name                             = "my-alb"
  internal                         = false
  load_balancer_type               = "application"
  security_groups                  = [var.ec2_sg_id]
  subnets                          = var.public_subnet_id
  enable_cross_zone_load_balancing = true

  tags = {
    Name = "my-alb"
  }
}

resource "aws_lb_target_group" "alb_tg" {
  name     = "alb-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    interval            = 30
    path                = "/"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "alb_tga" {
  count            = 2
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = var.ec2_id[count.index]
  port             = 8080
}
