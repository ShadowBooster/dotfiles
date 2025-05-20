#!/bin/bash
# A update script that commits on a successful build
set -e
HOSTNAME=$(hostname)
pushd ~/dotfiles/nixos/"${HOSTNAME}"

# When changes detected it doesn't run
if ! (git diff --quiet '*.nix'); then
    # Shows your changes
    git diff -U0 '*.nix'
    echo "changes detected, rebuild first before updating."
    exit 0
fi

echo "NixOS Updating..."
sudo nixos-rebuild switch --upgrade &> nixos-switch.log

if grep --color error nixos-switch.log; then
    exit 1
fi

echo "Deleting garbage..."
sudo nix-collect-garbage --delete-older-than 10d &>> nixos-switch.log

# Back to where you were
popd

# Notify all OK!
export QT_LOGGING_RULES="qt.multimedia.symbolsresolver=false"
kdialog --passivepopup "successfully updated your nixos system" 5 --title "NIXOS UPDATE OK"