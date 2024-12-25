resource "aws_s3_bucket" "app_shafiq_bucket" {
  bucket = "${var.environment}-app-shafiq-bucket"
  acl    = "private"
  tags = {
    Name = "${var.environment}-app-shafiq-bucket"
  }
}

resource "aws_db_instance" "app_shafiq_db" {
  allocated_storage      = 20
  max_allocated_storage  = 20
  engine                 = "mysql"
  instance_class         = "db.t2.micro"
  name                   = "${var.environment}_db"
  username               = var.db_username
  password               = var.db_password
  publicly_accessible    = false
  vpc_security_group_ids = [var.db_security_group_id]
  tags = {
    Name = "${var.environment}-app-shafiq-db"
  }
}
