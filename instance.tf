provider "aws" {
    region = "ap-south-1"
}
resource "aws_instance" "my_instance" {
    ami = ""
    instance_type = "t2.micro"
    key_name = "webapp-key"
    security_groups = ""
}
