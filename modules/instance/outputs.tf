output "instance_docker_id" {
    description= "ID of the EC2 instance with docker image"
    value=aws_instance.ec2_instance_docker.id
}

output "instance_docker_private_ip" {
    description= "Private IP of the EC2 instance with docker image"
    value=aws_instance.ec2_instance_docker.private_ip
}

output "instance_bastion_id" {
    description= "ID of the EC2"
    value=aws_instance.ec2_instance_bastion.id
}

output "instance_bastion_private_ip" {
    description= "Private IP of the EC2 instance with docker image"
    value=aws_instance.ec2_instance_bastion.private_ip
}

# output "security_group_loadbalancer_id" {
#     description= "ID of monitoring security group "
#     value=aws_security_group.loadbalancer.id
# }