#!/bin/bash
# A update script that commits on a successful build
set -e
pushd ~/dotfiles

# When changes detected it doesn't run
if ! (git diff --quiet '*.nix'); then
    # Shows your changes
    git diff -U0 '*.nix'
    echo "changes detected, rebuild first before updating."
    exit 0
fi

nh os switch flake.nix --upgrade --ask

nh clean all --keep 10

# Back to where you were
popd

# Notify all OK!
export QT_LOGGING_RULES="qt.multimedia.symbolsresolver=false"
kdialog --passivepopup "successfully updated your nixos system" 5 --title "NIXOS UPDATE OK"