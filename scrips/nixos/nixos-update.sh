#!/bin/bash
# A update script that commits on a successful build
set -e
pushd ~/dotfiles

# When changes detected it doesn't run
if ! (git diff --quiet); then
    # Shows your changes
    git diff -U0 '*.nix'
    echo "changes detected, rebuild first before updating."
    popd
    exit 0
fi

nh os switch /home/evelynvds/dotfiles --update --ask

# Cleaning up
nh clean all --keep 10

# Back to where you were
popd