
variable "vpc_cidr_block" {
    default = "10.0.0.0/16"
}
variable "subnet_cidr_block" {
    default = "10.0.0.0/24"
}
variable "avail_zone" {
    default = "eu-west-3b"
}
variable "env_prefix" {
    default = "dev"
}
variable "myip" {
    default = "0.0.0.0/0"
}
variable "instance-type" {
    default = "t2.micro"
}
//variable "public_key_location" {}
