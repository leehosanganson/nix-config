#!/usr/bin/env bash
set -e

# Stage
nix flake update dotfiles
git add .

# Rebuild
if [[ "$(uname)" == "Darwin" ]]; then
  if nix run github:nix-community/home-manager -- switch --flake git+file:.?submodules=1#ansonlee@mac-mini; then
    git commit -m "macOS Rebuild: $(date +'%Y-%m-%d %H:%M:%S')"
    git push origin main
    echo "macOS rebuilt"
  else
    echo "Build Failed. Fix the errors above. Nothing was committed"
    exit 1
  fi
else
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
fi

