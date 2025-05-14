# A rebuild script that commits on a successful build
set -e
pushd ~/dotfiles/nixos/

# Early return if no changes were detected
if git diff --quiet '*.nix'; then
    codium ShadowBoosterPC.nix ~/dotfiles/nixos/
    echo "No changes detected, exiting."
    popd
    exit 0
fi

statix check || echo "Statix check failed, but continuing..."
statix fix || echo "Statix fix failed, but continuing..."

# Autoformat your nix files
if ! nixfmt . &>/dev/null; then
    nixfmt . 
    echo "Formatting failed!"
    exit 1
fi

# Shows your changes
git diff -U0 '*.nix'

echo "NixOS Rebuilding..."

# Rebuild, output simplified errors, log trackbacks
if ! sudo nixos-rebuild switch &> nixos-switch.log; then
    grep --color error nixos-switch.log
    exit 1
fi

# Get current generation metadata
current=$(nixos-rebuild list-generations | grep current)

# Commit all changes witih the generation metadata
git commit -am "$current"

# Back to where you were
popd

# Notify all OK!
export QT_LOGGING_RULES="qt.multimedia.symbolsresolver=false"
kdialog --passivepopup "successfully rebuild your nixos system" 5 --title "NIXOS REBUILD OK"