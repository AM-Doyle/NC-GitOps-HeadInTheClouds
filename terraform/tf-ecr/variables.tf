variable "ecr_names" {
  type = list(string)
  default = [ "ce-fp-ecr-frontend", "ce-fp-ecr-backend" ]
}