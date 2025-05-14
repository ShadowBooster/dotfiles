# A update script that commits on a successful build
set -e

pushd ~/dotfiles/nixos/

if !(git diff --quiet '*.nix'); then
    # Shows your changes
    git diff -U0 '*.nix'
    echo "changes detected, rebuild first before updating."
    exit 0
fi

echo "NixOS Updating..."

sudo nixos-rebuild switch --upgrade &>nixos-switch.log || (cat nixos-switch.log | grep --color error && exit 1)

# Get current generation metadata
current=$(nixos-rebuild list-generations | grep current)

# Commit all changes witih the generation metadata
git commit -am "$current"

# Notify all OK!
export QT_LOGGING_RULES="qt.multimedia.symbolsresolver=false"
kdialog --passivepopup "successfully rebuild your nixos system" 5 --title "NIXOS REBUILD OK"