terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}


#create network infrastructure and security groups
module "network"{
    source = "./modules/network"
}

#create EC2 instance and  Application load balancer
module "instance"{
    source = "./modules/instance"
    vpc_id=module.network.vpc_id
    public_subnet=module.network.public_subnet
    private_subnet=module.network.private_subnet
    public_subnet_avz=module.network.public_subnet_avz
    public_subnet_sgr=module.network.public_subnet_sgr
    private_subnet_sgr=module.network.private_subnet_sgr
    
}
