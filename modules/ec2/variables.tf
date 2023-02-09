variable "server_port" {
  type        = string
  description = "server-port"
}

variable "image_id" {
  type        = string
  description = "ami-kind"
}

variable "instance_type" {
  type        = string
  description = "instance-type"
}


variable "public_subnet_id" {}

variable "vpc_id" {}
