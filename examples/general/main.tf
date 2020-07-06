module "ami" {
  source = "git::https://github.com/nakt/tf-module-ami-search"
  os     = "ubuntu"
}

module "instance" {
  source          = "../../"
  source_cidr     = var.source_cidr
  label_namespace = var.label_namespace
  label_name      = var.label_name
  label_stage     = var.label_stage
  label_extratags = var.label_extratags
  ami_id          = module.ami.ami-id
}
