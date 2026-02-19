# tail2c2

Terraform config that launches a t4g.nano (ARM/Graviton) EC2 instance running Amazon Linux 2023 with Tailscale SSH — no public SSH access.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.5
- AWS credentials configured (`aws configure` or environment variables)
- A Tailscale [auth key](https://login.tailscale.com/admin/settings/keys) (pre-authorized recommended)

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your Tailscale auth key

terraform init
terraform plan
terraform apply
```

The instance appears in your Tailscale admin console within ~30 seconds. Connect via:

```bash
ssh tail2c2
```

## Teardown

```bash
terraform destroy
```

Also remove the node from your [Tailscale admin console](https://login.tailscale.com/admin/machines) if using a single-use auth key.

## Resources Created

| Resource | Description |
|---|---|
| `aws_security_group` | Egress-only (no inbound rules) |
| `aws_instance` | t4g.nano, AL2023 ARM64, Tailscale via user_data |
