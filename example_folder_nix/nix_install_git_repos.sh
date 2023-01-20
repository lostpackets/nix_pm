#!/usr/bin
# This installs oh-my-bash via your /nix dir, and uses the command nix-env -i -f oh-my-bash.nix to find and install it through your nix pkg.
cd /nix
nix-env -i -f oh-my-bash.nix

