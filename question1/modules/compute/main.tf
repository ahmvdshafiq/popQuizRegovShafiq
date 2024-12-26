#Defines the reusable ec2 instance infrastructure resources

resource "aws_instance" "app_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name = "app-server-${var.environment}"
  }
}

