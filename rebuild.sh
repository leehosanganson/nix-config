#!/usr/bin/env bash
set -e

usage() {
  echo "Usage: $(basename "$0") [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  --update-secrets    Update the secrets flake input before rebuilding"
}

# Arguments
UPDATE_SECRET=false

for arg in "$@"; do
  case $arg in
    --update-secrets)
      UPDATE_SECRET=true
      shift
      ;;
    *)
      echo "Error: unrecognized argument '$arg'"
      usage
      exit 1
      ;;
  esac
done

if [ "$UPDATE_SECRET" = "true" ]; then
  nix flake update secrets
fi

# Stage
git add .

# Rebuild
if [[ "$(uname)" == "Darwin" ]]; then
  if sudo darwin-rebuild switch --flake .#$(hostname); then
    gen=$(sudo darwin-rebuild --list-generations | grep current | awk '{print $1}')
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
