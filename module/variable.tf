variable "vpc_cidr_block" {
        default = "192.168.0.0/16"
}
variable "public_cidr_block" {
        default = "192.168.0.0/24"
}

variable "private_cidr_block" {
        default = "192.168.1.0/24"
}


variable "from_port" {
        default = "0"
}

variable "to_port" {
        default = "65535"
}