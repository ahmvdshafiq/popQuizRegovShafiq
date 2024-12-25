module "networking" {
  source = "/home/mad/terraform/terraform/modules/net"

  cidr_block        = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
  environment       = "dev"
}

module "compute" {
  source = "/home/mad/terraform/terraform/modules/compute"

  ami_id      = "ami-0c02fb55956c7d316" 
  environment = "dev"
  networking  = module.networking
}

module "storage" {
  source = "/home/mad/terraform/terraform/modules/storage"

  environment = "dev"
}
