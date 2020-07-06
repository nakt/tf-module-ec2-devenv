variable source_cidr {}
variable label_namespace {
  default = "nakt"
}
variable label_name {
  default = "workspace"
}
variable label_stage {
  default = "dev"
}

variable label_extratags {
  default = {
    "Owner" = "nakt"
  }
}
