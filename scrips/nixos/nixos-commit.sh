#!/bin/bash
# A rebuild script that commits on a successful build
set -e
HOSTNAME=$(hostname)
pushd /etc/nixos

# Lints nix files
if ! statix check; then
    echo "Warning: Statix check failed, but continuing..."
fi
if ! statix fix; then
    echo "Warning: Statix fix failed, but continuing..."
fi

# Autoformat your nix files
if ! nixfmt . &>/dev/null; then
    nixfmt . 
    echo "Formatting failed!"
    exit 1
fi

# Shows all nix changes
git diff -U0 '*.nix'

# Get a commit message
echo -n "Enter commit message: "
read -r commit_message

# Commit all changes
git commit -am "$commit_message"

# Back to where you were
popd
