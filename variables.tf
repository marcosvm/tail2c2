variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "tailscale_auth_key" {
  type      = string
  sensitive = true
}

variable "instance_name" {
  type    = string
  default = "tail2c2"
}
