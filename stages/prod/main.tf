provider "aws" {
  region = var.aws_region
}

module "compute" {
  source        = "../../modules/compute"
  ami_id        = var.ami_id
  instance_type = var.instance_type
  environment   = "prod"
}
