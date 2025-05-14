# A rebuild script that commits on a successful build
set -e
pushd ~/dotfiles/nixos/
codium ShadowBoosterPC.nix

# Early return if no changes were detected
if git diff --quiet '*.nix'; then
    echo "No changes detected, exiting."
    popd
    exit 0
fi

# Autoformat your nix files
nixfmt . &>/dev/null || ( nixfmt . ; echo "formatting failed!" && exit 1)

# Shows your changes
git diff -U0 '*.nix'

echo "NixOS Rebuilding..."

# Rebuild, output simplified errors, log trackebacks
sudo nixos-rebuild switch &>nixos-switch.log || (cat nixos-switch.log | grep --color error && exit 1)

# Get current generation metadata
current=$(nixos-rebuild list-generations | grep current)

# Commit all changes witih the generation metadata
git commit -am "$current"

# Back to where you were
popd

# Notify all OK!
export QT_LOGGING_RULES="qt.multimedia.symbolsresolver=false"
kdialog --passivepopup "successfully rebuild your nixos system" 5 --title "NIXOS REBUILD OK"