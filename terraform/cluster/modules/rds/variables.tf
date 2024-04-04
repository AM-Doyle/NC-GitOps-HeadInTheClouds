variable "db-subnet-group-name" {
  type = string
}
variable "subnet_ids" {
  type = list(string)
}
variable "db_name" {
  type = string
}
variable "instance_class" {
  type = string
}
variable "engine" {
  type = string
}
variable "engine_version" {
  type = string
}
variable "vpc_security_group_ids" {
  
}