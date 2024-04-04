variable "region" {
  description = "The Region To Create The Resources In."
  type        = string
  default     = "eu-west-2"
}

variable "aws_access_key" {
  description = "Access key of the IAM user"
  type = string
}

variable "aws_secret_access_key" {
  description = "Secret access key of the IAM user"
  type = string
}

variable "instance_type" {
  description = "Type of instance to launch Jenkins in; t2.medium and above recommended"
  type = string
  default = "t2.small"
}
variable "key_pair" {
  description = "SSH key to remote-exec into the instance"
  type = string
}
variable "key_pair_name" {
  description = "SSH key name"
  type = string
}
variable "jenkins_image" {
  description = "The image containing your JCasC configuration"
  type = string
  default = "tribbl3/jenkins:jcasc"
}
variable "jenkins_container_name" {
  description = "Name of the container to launch Jenkins in"
  type = string
  default = "jenkins_container"
}
variable "jenkins_admin_id" {
  description = "Initial username for Jenkins"
  type = string
  default = "jenkins"
}
variable "jenkins_admin_password" {
  description = "Password for Jenkins username"
  type = string
  default = "password"
}

variable "cidr_block" {
  description = "Open CIDR"
  type = string
  default = "0.0.0.0/0"
}