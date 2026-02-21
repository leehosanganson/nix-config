#!/usr/bin/env bash

cd ~/nix-config

nixpkgs-fmt *.nix hosts/**/*.nix

git add .

if sudo nixos-rebuild switch --flake .#$(hostname); then
  gen=$(nixos-rebuild list-generations | grep current | awk '{print $1}')
  git commit -m "Generation $gen: $(date +'%Y-%m-%d %H:%M:%S')"
  git push origin main
  echo "$HOSTNAME rebuilt - gen $gen"
else
  echo "Build Failed. Fix the errors above. Nothing was committed"
  exit 1
fi

DOTFILES="$HOME/.dotfiles"
if [ ! -d "$DOTFILES" ]; then
    echo "Cloning dotfiles..."
    git clone https://github.com/leehosanganson/dotfiles.git "$DOTFILES"
fi

cd "$DOTFILES"
chmod +x install.sh
./install.sh

echo "dotfiles synced"nix
cd ~/nix-config
