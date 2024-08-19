# Application Load Balancer
resource "aws_lb" "app_lb_2" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_alb.id]
  subnets            = module.vpc.public_subnets

  enable_deletion_protection = false
  enable_http2              = true

  tags = {
    Name = "app-lb-2"
  }
}

# ALB HTTPS Listener
resource "aws_lb_listener" "https2" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 443
  protocol          = "HTTPS"

 default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins.arn
  }

  certificate_arn = "arn:aws:acm:ap-south-1:286291623788:certificate/87e58756-beac-4ad6-8930-c3ff109dfa2e" 

  depends_on = [
    aws_lb.app_lb_2,
    aws_lb_target_group.jenkins_2
  ]
}



# ALB HTTP Listener with redirection to HTTPS
resource "aws_lb_listener" "http2" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      host     = "#{host}"
      path     = "/#{path}"
      port     = "443"
      protocol = "HTTPS"
      query    = "#{query}"
      status_code = "HTTP_301"
    }
  }

  depends_on = [
    aws_lb.app_lb_2
  ]
}

# Target Group for Jenkins
resource "aws_lb_target_group" "jenkins_2" {
  name     = "jenkins-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  

  tags = {
    Name = "jenkins-tg_2"
  }
}

# Attach EC2 instances to the Target Group
resource "aws_lb_target_group_attachment" "jenkins_instance_attachment_2" {
  count              = 1
  target_group_arn   = aws_lb_target_group.jenkins_2.arn
  target_id          = "i-0dd651dd53bef2f02"
  port               = 8081

  depends_on = [
    aws_lb_target_group.jenkins,
    aws_instance.private_instance
  ]
}
