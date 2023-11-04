resource "asw_lb_target_group" "target-group" {
    health_check {
       interval  = 10
       path      = "/"
       protocol  = "HTTP"
       timeout   = 5
       healthy_threshold = 5
       unhealthy_threshold = 2
    }

     name  = "app-tg"
     port  = 80
     protocol = "HTTP"
     target_type  = "instance"
     vpc_id  = 
