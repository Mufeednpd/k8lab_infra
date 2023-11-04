#target group
resource "aws_lb_target_group" "worker_target_group" {
    health_check {
       interval  = 10
       path      = "/"
       protocol  = "HTTP"
       timeout   = 5
       healthy_threshold = 5
       unhealthy_threshold = 2
    }

     name  = "worker-target-group"
     port  = 30259
     protocol = "HTTP"
     target_type  = "instance"
     vpc_id  = aws_vpc.vpc.id
}

#Creating ALB
resource "aws_lb" "application_alb" {
    name  = "app-alb"
    internal   = false
    ip_address_type = "ipv4"
    load_balancer_type  = "application"
    subnets      = ["subnet-0193368b0ed42ac2c"]
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
    
resource "aws_lb_listener_rule" "app_listener_rule" {
  listener_arn = aws_lb_listener.application_alb_listener.arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.worker_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }
}
