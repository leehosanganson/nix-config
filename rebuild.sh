#!/usr/bin/env bash

CONF_FILES="$HOME/nixos-config"
DOTFILES="$HOME/.dotfiles"

set -e

# Dotfiles
if [ ! -d "$DOTFILES" ]; then
    echo "Cloning dotfiles..."
    git clone https://github.com/leehosanganson/dotfiles.git "$DOTFILES"
else
    echo "Syncing latest secrets from Dotfiles..."
    # Optional: Pull latest changes if you want the script to be fully hands-off
    cd "$DOTFILES" && git pull && cd "$CONF_FILES"
fi

cd "$CONF_FILES"

# 2. Sync the Flake Lock
echo "Updating dotfiles reference in NixOS..."
nix flake update dotfiles

# Format
find . -path './.git' -prune -o -name "*.nix" -type f -print0 | xargs -0 nixpkgs-fmt

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

