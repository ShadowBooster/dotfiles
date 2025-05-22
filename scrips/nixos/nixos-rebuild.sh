#!/bin/bash
# A rebuild script that commits on a successful build
set -e
HOSTNAME=$(hostname)
pushd ~/dotfiles

# Early return if no changes were detected
if git diff --quiet '*.nix'; then
    codium /hosts/ShadowBoosterPC/configuration.nix ~/dotfiles/
    echo "No changes detected, exiting."
    popd
    exit 0
fi

# Lints nix files
statix check || echo "Statix check failed, but continuing..."
statix fix || echo "Statix fix failed, but continuing..."

# Autoformat your nix files
if ! nixfmt . &>/dev/null; then
    nixfmt . 
    echo "Formatting failed!"
    exit 1
fi

# Shows all changes
git diff -U0 '*.nix'

nh os switch /home/evelynvds/dotfiles --ask

# Get current generation metadata
current=$(nixos-rebuild list-generations | grep current)

# Commit all changes witih the generation metadata
git commit -am "$current"

# Back to where you were
popd

# Notify all OK!
export QT_LOGGING_RULES="qt.multimedia.symbolsresolver=false"
kdialog --passivepopup "successfully rebuild your nixos system" 5 --title "NIXOS REBUILD OK"