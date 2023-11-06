
# # create alb target group for k8workers

#  resource "aws_lb_target_group" "k8workers01" {
#    name     = "k8workers"
#    port     = 30259
#    protocol = "HTTP"
#    vpc_id   = aws_vpc.vpc.id
#    target_type = "instance"
  
#  }


#  resource "aws_lb" "alb" {
#    name               = "weblb"
#    internal           = false
#    load_balancer_type = "application"
#    security_groups    = [aws_security_group.alb.id]
#    subnets            = [aws_subnet.pub_subnet.id,aws_subnet.pub_subnet2.id]

#    tags = {
#      Environment = "dev"
#    }
#  }


 # attach  k8 worker nodes in AZ a



 resource "aws_lb_target_group_attachment" "k8workers_az_a" {
   count = 1
   target_group_arn = aws_lb_target_group.k8workers.arn
   target_id        = aws_instance.k8workers_az_a[count.index].id
   port             = 30259
 }


 # attach  k8 worker nodes in AZ b



 resource "aws_lb_target_group_attachment" "k8workers_az_b" {
   count = 1
   target_group_arn = aws_lb_target_group.k8workers.arn
   target_id        = aws_instance.k8workers_az_b[count.index].id
   port             = 30259
 }


# creat listener for k8 workers

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = "arn:aws:acm:us-east-1:118091114135:certificate/8119987b-73c3-4bc4-90c1-57f03d6a7e95"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.k8workers.arn
  }
}
