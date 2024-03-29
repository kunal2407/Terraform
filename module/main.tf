provider "aws" {
  region = "ap-south-1"
}
module "vpc" {
 source  = "./vpc"
 vpc_cidr_block     = var.vpc_cidr_block
 public_cidr_block  = var.public_cidr_block
 private_cidr_block = var.private_cidr_block
 from_port          = var.from_port
 to_port            = var.to_port
}
