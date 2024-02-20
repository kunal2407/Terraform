provider "aws" {
    region = "ap-south-1"
}
resource "aws_instance" "my_instance" {
    ami = "ami-0e670eb768a5fc3d4"
    instance_type = "t2.micro"
    key_name = "webapp-key"
    tags = {
      Name = "new-instance"
    }
  
}