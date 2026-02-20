# tail2c2

Terraform config that launches a t4g.nano (ARM/Graviton) EC2 instance running Amazon Linux 2023 with Tailscale SSH — no public SSH access.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.5
- AWS CLI configured (`aws configure` or environment variables)
- A Tailscale [auth key](https://login.tailscale.com/admin/settings/keys) (pre-authorized recommended)

## Getting a Tailscale Auth Key

1. Open the [Tailscale admin console](https://login.tailscale.com/admin/settings/keys)
2. Click **Generate auth key**
3. Enable **Reusable** if you plan to recreate the instance, otherwise leave as single-use
4. Enable **Pre-approved** so the node joins without manual approval
5. Copy the key (starts with `tskey-auth-`)

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
ssh ec2-user@tail2c2
```

The default user for Amazon Linux 2023 is `ec2-user`.

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

## Peer Relay

The `enable_peer_relay` variable (default `false`) configures the instance as a [Tailscale peer relay](https://tailscale.com/kb/1459/peer-relay). When enabled:

- `tailscale set --relay-server-port=40000` runs during provisioning
- UDP port 40000 is opened inbound in the security group

Set it in your `terraform.tfvars`:

```hcl
enable_peer_relay = true
```

Changing this toggle replaces the instance (user_data changes trigger recreation).

### Tailscale ACL prerequisite

A grant must be added in the Tailscale admin console (Access Controls → Policy file) to allow devices to use the relay:

```json
{
  "grants": [{
    "src": ["autogroup:member"],
    "dst": ["tag:relay"],
    "app": { "tailscale.com/cap/relay": [] }
  }]
}
```

The EC2 node must also be tagged `tag:relay` in the Tailscale admin console.

## Resources Created

| Resource | Description |
|---|---|
| `aws_security_group` | Egress-only by default; UDP 40000 ingress when relay enabled |
| `aws_security_group_rule.relay_udp` | Conditional UDP 40000 ingress for peer relay |
| `aws_instance` | t4g.micro (Free Tier), AL2023 ARM64, Tailscale via user_data |
