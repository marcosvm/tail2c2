#!/bin/bash
set -euo pipefail
dnf config-manager --add-repo https://pkgs.tailscale.com/stable/amazon-linux/2023/tailscale.repo
dnf install -y tailscale
systemctl enable --now tailscaled
tailscale up --authkey="${tailscale_auth_key}" --hostname="${instance_name}" --ssh
