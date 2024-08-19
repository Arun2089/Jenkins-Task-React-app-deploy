# Application Load Balancer
resource "aws_lb" "app_lb_2" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_alb_2.id]
  subnets            = ["subnet-0bb331ad660bbb788","subnet-0f0fb8740b3cafafc"]

  enable_deletion_protection = false

  tags = {
    Name = "app-lb-2"
  }
}

# ALB HTTPS Listener
resource "aws_lb_listener" "https2" {
  load_balancer_arn = aws_lb.app_lb_2.arn
  port              = 443
  protocol          = "HTTPS"

 default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins_2.arn
  }

  certificate_arn = "arn:aws:acm:ap-south-1:286291623788:certificate/87e58756-beac-4ad6-8930-c3ff109dfa2e" 

  depends_on = [
    aws_lb.app_lb_2,
    aws_lb_target_group.jenkins_2
  ]
}



# ALB HTTP Listener with redirection to HTTPS
resource "aws_lb_listener" "http2" {
  load_balancer_arn = aws_lb.app_lb_2.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      
      port     = "443"
      protocol = "HTTPS"
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
  port     = 8081
  protocol = "HTTP"
  vpc_id   = vpc-0dd41e1aa1ccc4b46
  

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
    aws_lb_target_group.jenkins_2,
    
  ]
}
