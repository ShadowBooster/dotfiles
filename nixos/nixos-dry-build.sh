#!/bin/bash
set -e
HOSTNAME=$(hostname)
pushd ~/dotfiles/nixos/"${HOSTNAME}"

echo "NixOS dry-building..."
sudo nixos-rebuild dry-build