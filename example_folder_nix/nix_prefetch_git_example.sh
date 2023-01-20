#!/usr/bin
# This searches for any github proj hash, etc.
if [[ -x "$(command -v nix-prefetch-git)" ]]; then
    echo "nix-prefetch-git is executable"
else
    echo "nix-prefetch-git is not executable"
    echo "Installing nix-prefetch-git..."
    nix-env -iA nixpkgs.nix-prefetch-git

fi
nix-prefetch-git https://github.com/ohmybash/oh-my-bash.git HEAD
