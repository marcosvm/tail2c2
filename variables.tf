variable "aws_region" {
  type    = string
  default = "us-west-2"
}

variable "tailscale_auth_key" {
  type      = string
  sensitive = true
}

variable "instance_name" {
  type    = string
  default = "tail2c2"
}

variable "enable_peer_relay" {
  type    = bool
  default = false
}
