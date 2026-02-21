#!/usr/bin/env bash

sudo nixos-rebuild switch --flake .#lhs-nix
echo "nixos rebuilt"

DOTFILES="$HOME/.dotfiles"
if [ ! -d "$DOTFILES" ]; then
    echo "Cloning dotfiles..."
    git clone https://github.com/leehosanganson/dotfiles.git "$DOTFILES"
fi

cd "$DOTFILES"
chmod +x install.sh
./install.sh

echo "dotfiles synced"
