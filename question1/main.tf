provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

module "networking" {
  source             = "./modules/networking"
  cidr_block         = var.environment_config[var.environment].cidr_block
  public_subnet_cidr = var.environment_config[var.environment].public_subnet_cidr
  environment        = var.environment
}

module "compute" {
  source            = "./modules/compute"
  ami_id            = var.environment_config[var.environment].ami_id
  instance_type     = var.environment_config[var.environment].instance_type
  subnet_id         = module.networking.public_subnet_id
  security_group_id = module.networking.security_group_id
  environment       = var.environment
}
