#!/bin/bash
# A rebuild script that commits on a successful build
set -e
HOSTNAME=$(hostname)
pushd ~/dotfiles

# Early return if no changes were detected
if ! (git diff --quiet); then
    codium ~/dotfiles/hosts/ShadowBoosterPC/configuration.nix ~/dotfiles/
    echo "changes detected, not switching on dirty git tree"
    popd
    exit 0
fi

# Rebuild with Nixos rebuild helper
nh os switch --ask

# Get current generation metadata
current=$(nixos-rebuild list-generations | grep current)

# Commit all changes witih the generation metadata
git commit -am "$current"

# Back to where you were
popd