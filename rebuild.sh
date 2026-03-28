#!/usr/bin/env bash

CONF_FILES="$HOME/nixos-config"

set -e

cd "$CONF_FILES"

# Format
find . -path './.git' -prune -o -name "*.nix" -type f -print0 | xargs -0 nixpkgs-fmt

# Stage
nix flake update dotfiles
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

