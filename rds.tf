provider "aws" {
  region = "ap-south-1" // Specify your desired AWS region
}

resource "aws_db_instance" "my_rds" {
  identifier           = "mydbinstance"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = "Password123"
}
