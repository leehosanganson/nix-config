#!/usr/bin/env bash

CONF_FILES="$HOME/nixos-config"
DOTFILES="$HOME/.dotfiles"

set -e

# Dotfiles
if [ ! -d "$DOTFILES" ]; then
    echo "Cloning dotfiles..."
    git clone https://github.com/leehosanganson/dotfiles.git "$DOTFILES"
fi

cd "$CONF_FILES"

# Format
nixpkgs-fmt *.nix

# Stage
git add .

# Rebuild
if sudo nixos-rebuild switch --flake .#$(hostname); then
  # Commit the changes
  gen=$(nixos-rebuild list-generations | grep True | awk '{print $1}')
  git commit -m "Generation $gen: $(date +'%Y-%m-%d %H:%M:%S')"
  git push origin main

  echo "$HOSTNAME rebuilt - gen $gen"
else
  echo "Build Failed. Fix the errors above. Nothing was committed"
  exit 1
fi

