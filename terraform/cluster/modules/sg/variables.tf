variable "vpc_id" {
  type        = string
  description = "The VPC ID that you wish to create the security groups in"
}

variable "cidr_0" {
  type = string
  description = "CIDR block of 0.0.0.0/0"
  default = "0.0.0.0/0"
}

variable "cird_16" {
  type = string
  description = "CIDR block of 10.0.0.0/16"
  default = "10.0.0.0/16"
}

variable "protocol" {
  type = string
  description = "Protocol for the connection"
  default = "tcp"
}

variable "app_port" {
  type = list(number)
  description = "The port apps listen on"
  default = [ 80, 8080 ]
}

variable "ssh_port" {
  type = number
  description = "SSH port 22"
  default = 22
}

variable "database_port" {
  type = number
  description = "Database port"
  default = 5432
}