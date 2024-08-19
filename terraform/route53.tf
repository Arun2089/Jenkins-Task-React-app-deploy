resource "aws_route53_record" "alb_record_2" {
  zone_id = "Z01289041WN99TK7TRRUC"
  name    = "react.arunlohar.online"  
  type    = "A"

  alias {
    name                   = aws_lb.app_lb_2.dns_name
    zone_id                = aws_lb.app_lb_2.zone_id
    evaluate_target_health = true
  }


}
