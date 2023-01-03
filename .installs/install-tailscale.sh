#!/usr/bin/env bash
sudo dnf config-manager --add-repo https://pkgs.tailscale.com/stable/oracle/8/tailscale.repo
sudo dnf install -y tailscale
sudo systemctl enable --now tailscaled
sudo tailscale up
ip addr show tailscale0
