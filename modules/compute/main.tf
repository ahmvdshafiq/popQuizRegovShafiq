#configure ec2 instance

resource "aws_instance" "app_instance_shafiq" {
  ami           = var.ami_id 
  instance_type = "t2.micro" 

  subnet_id = module.networking.public_subnet_id
  security_groups = [
    module.networking.security_group_id
  ]

  tags = {
    Name = "app-${var.environment}"
  }
}
