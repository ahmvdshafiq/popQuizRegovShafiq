module "networking" {
  source = "/home/mad/terraform/terraform/modules/networ"

  cidr_block        = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
  environment       = "uat"
}

module "compute" {
  source = "/home/mad/terraform/terraform/modules/compute"

  ami_id      = "ami-0c02fb55956c7d316" 
  environment = "uat"
  networking  = module.networking
}

module "storage" {
  source = "/home/mad/terraform/terraform/modules/storage"

  environment = "uat"
}
