# tail2c2

Terraform config that launches a t4g.nano (ARM/Graviton) EC2 instance running Amazon Linux 2023 with Tailscale SSH — no public SSH access.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.5
- AWS CLI configured (`aws configure` or environment variables)
- A Tailscale [auth key](https://login.tailscale.com/admin/settings/keys) (pre-authorized recommended)

## Usage

### 1. Bootstrap the deployer IAM role (one-time, requires admin)

```bash
make bootstrap
```

### 2. Deploy the instance

```bash
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your Tailscale auth key

make deploy
```

The instance appears in your Tailscale admin console within ~30 seconds. Connect via:

```bash
ssh tail2c2
```

### Other targets

| Target | Description |
|---|---|
| `make plan` | Preview changes using the deployer role |
| `make deploy` | Apply changes using the deployer role |
| `make destroy` | Tear down EC2 resources |
| `make bootstrap-destroy` | Remove the IAM deployer role |

## Teardown

```bash
make destroy
```

Also remove the node from your [Tailscale admin console](https://login.tailscale.com/admin/machines) if using a single-use auth key.

## Resources Created

| Resource | Description |
|---|---|
| `aws_security_group` | Egress-only (no inbound rules) |
| `aws_instance` | t4g.nano, AL2023 ARM64, Tailscale via user_data |
