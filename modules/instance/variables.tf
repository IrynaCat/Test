variable "vpc_id" {
    description = "ID vpc"
    type = string
}

variable "ami" {
    description="The type of ami (Ubuntu Server 20.04) eu-central-1"
    type = string
    default="ami-05f7491af5eef733a"
}

variable "instance_type_docker" {
    description = "The type of EC2 instance to run (t2.small)"
    type = string
    default="t2.small"
}

variable "instance_type_bastion" {
    description = "The type of EC2 instance to run (t2.small)"
    type = string
    default="t2.micro"
}

# variable "my_ip_cidr_block"{
#     description = "My ip for security groups"
# }

variable "public_subnet"{
    description = "Public subnet"
}

variable "public_subnet_avz"{
    description = "Public subnet avz"
}


variable "private_subnet"{
   description = "Private subnet"
}

variable "public_subnet_sgr"{
   description = "Allow all connection from my ip"
}

variable "private_subnet_sgr"{
   description = "Allow port 8080 and egress connections"
}

# locals {
#     my_ip_cidr_block="95.47.59.252/32"
# }