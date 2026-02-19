data "aws_ami" "al2023_arm64" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-arm64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "this" {
  name        = "${var.instance_name}-sg"
  description = "Egress-only for Tailscale"
  vpc_id      = data.aws_vpc.default.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "this" {
  ami                    = data.aws_ami.al2023_arm64.id
  instance_type          = "t4g.nano"
  vpc_security_group_ids = [aws_security_group.this.id]

  user_data = templatefile("${path.module}/user_data.sh", {
    tailscale_auth_key = var.tailscale_auth_key
    instance_name      = var.instance_name
  })

  tags = {
    Name = var.instance_name
  }
}
