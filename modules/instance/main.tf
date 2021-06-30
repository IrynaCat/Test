resource "aws_instance" "ec2_instance_docker" {
    ami=var.ami
    instance_type=var.instance_type_docker
    key_name="key"
    vpc_security_group_ids=[var.private_subnet_sgr]
    subnet_id=var.private_subnet
    monitoring=true
    user_data=file("${path.module}/docker.sh")

    tags={
        Name="Docker instance"
    }
}


resource "aws_instance" "ec2_instance_bastion" {
    ami=var.ami
    instance_type=var.instance_type_bastion
    key_name="key"
    vpc_security_group_ids=[var.public_subnet_sgr]
    subnet_id=var.public_subnet
    monitoring=true

    tags={
        Name="Bastion instance"
    }
}


#create loadbalancer security group
# resource "aws_security_group" "loadbalancer" {
#   name="Loadbalancer security group"
 
#   vpc_id=var.vpc_id

#   ingress {
#     description = "Allow all"
#     protocol  = "-1"
#     self      = true
#     from_port = 0
#     to_port   = 0
#     cidr_blocks = ["31.148.149.249/32"]
#   }

#   egress {
#     description="Allow all"
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     self        = true
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags={
#     Name="lb_scgroup"
#   }
# }

#create loadbalancer
resource "aws_alb" "loadbalancer" {
  name            = "Loadbalancer"
  internal           = false
  load_balancer_type = "application"
  subnets=[var.public_subnet, var.public_subnet_avz]
  security_groups = [var.public_subnet_sgr]

  tags ={
    Name="application_lb"
  }
}

resource "aws_lb_target_group" "docker_port_tg" {
  name     = "dockertg"
  port     = 8080
  protocol = "HTTP"
  vpc_id=var.vpc_id

  tags={
        Name="docker_tg"
    }
}

resource "aws_lb_listener" "docker_listener" {
  load_balancer_arn = aws_alb.loadbalancer.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.docker_port_tg.arn
  }
}

resource "aws_lb_listener_rule" "static_docker" {
  listener_arn = aws_lb_listener.docker_listener.arn
  priority     = 50

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.docker_port_tg.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}


resource "aws_lb_target_group_attachment" "docker" {
  target_group_arn = aws_lb_target_group.docker_port_tg.arn
  target_id        = aws_instance.ec2_instance_docker.id
}
