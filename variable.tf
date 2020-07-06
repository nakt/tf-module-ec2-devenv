#
# Labeling
#
#
variable label_namespace {}
variable label_name {}
variable label_stage {}
variable label_delimiter {
  default = "-"
}
variable label_attributes {
  default = []
}
variable label_extratags {
  default = {}
}

#
# Network Params
#
variable region {
  default = "us-east-1"
}

variable vpc_cidr_block {
  default = "10.128.0.0/16"
}

variable source_cidr {}

#
# Instance
#

variable instance_count {
  default = 1
}

variable ami_id {}
variable instance_type {
  default = "t3.micro"
}

variable sshkey_path {
  default = "~/.ssh/dev"
}
