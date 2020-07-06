data "aws_availability_zones" "available" {}

module "label" {
  source = "git::https://github.com/cloudposse/terraform-null-label?ref=tags/0.16.0"

  namespace  = var.label_namespace
  name       = var.label_name
  stage      = var.label_stage
  delimiter  = var.label_delimiter
  attributes = var.label_attributes
  tags       = var.label_extratags
}

resource "aws_key_pair" "ssh_key" {
  key_name   = module.label.id
  public_key = file(format("%s/%s.pub", var.sshkey_path, module.label.id))
  tags       = module.label.tags
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = module.label.id
  cidr                 = var.vpc_cidr_block
  azs                  = [data.aws_availability_zones.available.names[0]]
  public_subnets       = [cidrsubnet(var.vpc_cidr_block, 8, 1)]
  enable_nat_gateway   = false
  enable_vpn_gateway   = false
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = module.label.tags
}

module "security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name                = module.label.id
  description         = "Security group for workspace with HTTP/HTTPS/ssh ports open within VPC"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = [var.source_cidr]
  ingress_rules       = ["http-80-tcp", "https-443-tcp", "ssh-tcp"]
  egress_rules        = ["all-all"]
  tags                = module.label.tags
}

module "instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  instance_count              = var.instance_count
  name                        = module.label.id
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = module.label.id
  associate_public_ip_address = true
  monitoring                  = false
  vpc_security_group_ids      = [module.security_group.this_security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  tags                        = module.label.tags
  user_data                   = "${file("${path.module}/userdata.sh")}"
}
