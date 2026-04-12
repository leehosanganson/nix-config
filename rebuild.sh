#!/usr/bin/env bash
set -e

# Arguments
FLAKE_UPDATE=false

for arg in "$@"; do
  case $arg in
    --update-flake)
      FLAKE_UPDATE=true
      shift
      ;;
    *)
      # Unknown option, just pass it along
      shift
      ;;
  esac
done

if [ "$FLAKE_UPDATE" = "true" ]; then
  nix flake update secrets
fi

# Stage
git add .

# Rebuild
if [[ "$(uname)" == "Darwin" ]]; then
  if sudo darwin-rebuild switch --flake .#mac-mini; then
    gen=$(darwin-rebuild list-generations | grep True | awk '{print $1}')
    git commit -m "$HOSTNAME OSX Generation $gen: $(date +'%Y-%m-%d %H:%M:%S')"
    git push origin main
    echo "$HOSTNAME rebuilt - gen $gen"
  else
    echo "Build Failed. Fix the errors above. Nothing was committed"
    exit 1
  fi
elif [[ -f /etc/NIXOS ]]; then
  if sudo nixos-rebuild switch --flake .#$(hostname); then
    # Commit the changes
    gen=$(nixos-rebuild list-generations | grep True | awk '{print $1}')
    git commit -m "$HOSTNAME NixOs Generation $gen: $(date +'%Y-%m-%d %H:%M:%S')"
    git push origin main

    echo "$HOSTNAME rebuilt - gen $gen"
  else
    echo "Build Failed. Fix the errors above. Nothing was committed"
    exit 1
  fi
else
  echo "Unknown OS. Nothing was committed"
  exit 1
fi

