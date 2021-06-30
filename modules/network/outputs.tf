output "vpc_id" {
    description= "ID of VPC"
    value=aws_vpc.vpc_test.id
}

output "public_subnet" {
    description= "Public subnet ID"
    value=aws_subnet.public_subnet.id
}

output "private_subnet" {
    description= "Private subnet ID"
    value=aws_subnet.private_subnet.id
}

output "public_subnet_avz" {
    description= "Public subnet ID Availability Zone"
    value=aws_subnet.public_subnet_avz.id
}

output "public_subnet_sgr" {
    description= "Security group for public subnet"
    value=aws_security_group.public_subnet_sgr.id
}

output "private_subnet_sgr" {
    description= "Security group for private subnet"
    value=aws_security_group.private_subnet_sgr.id
}

