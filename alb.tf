#target group
resource "asw_lb_target_group" "target-group" {
    health_check {
       interval  = 10
       path      = "/"
       protocol  = "HTTP"
       timeout   = 5
       healthy_threshold = 5
       unhealthy_threshold = 2
    }

     name  = "worker-tg"
     port  = 30259
     protocol = "HTTP"
     target_type  = "instance"
     vpc_id  = aws_vpc.vpc.id
}

#Creating ALB
resource "aws_lb" "application_alb" {
    name  = "app-alb"
    internal   = False
    ip_address_type = "ipv4"
    load_balancer_type  = "application"
    subnets  = aws_subnet.pub_subnet.id
}

resource "aws_lb_listener" "application_alb_listener" {
  load_balancer_arn = aws_lb.application_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
      message_body = "OK"
    }
  }
}
    

