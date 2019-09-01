# LOAD BALANCER #
resource "aws_elb" "web" {
  name = "nginx-elb"

  subnets         = [for s in aws_subnet.subnets : s.id]
  security_groups = [aws_security_group.elb-sg.id]
  instances       = [for i in aws_instance.instances : i.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}
