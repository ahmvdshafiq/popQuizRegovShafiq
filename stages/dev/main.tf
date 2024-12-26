#create resources specific dev stage

provider "aws" {
  region = var.aws_region
}

module "compute" {
  source        = "../../modules/compute"
  ami_id        = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  environment   = "dev"
}
