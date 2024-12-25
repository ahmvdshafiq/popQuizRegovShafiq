module "networking" {
  source = "../../modules/networking"

  cidr_block        = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
  environment       = "uat"
}

module "compute" {
  source = "../../modules/compute"

  ami_id      = "ami-0c02fb55956c7d316" # Free Tier Amazon Linux 2
  environment = "uat"
  networking  = module.networking
}

module "storage" {
  source = "../../modules/storage"

  environment = "uat"
}
