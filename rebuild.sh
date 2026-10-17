#!/usr/bin/env bash
set -e

usage() {
  echo "Usage: $(basename "$0") [--host HOST] [--update-secrets]"
  echo "Stage the configuration files you intend to deploy with git add before running this script."
  echo "Only already-staged changes are committed after a successful rebuild."
  echo "With --update-secrets, stage any resulting flake.lock update and rerun the script."
  echo ""
  echo "Options:"
  echo "  --host HOST         Rebuild the named flake host (lhs-desktop, lhs-mbp, mac-mini)"
  echo "  --update-secrets    Update the secrets flake input before rebuilding"
  echo "  -h, --help          Show this help"
}

UPDATE_SECRET=false
HOST=""
HOST_SET=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --update-secrets)
      UPDATE_SECRET=true
      shift
      ;;
    --host)
      if [[ $# -lt 2 || -z "$2" ]]; then
        echo "Error: --host requires a host name" >&2
        usage >&2
        exit 1
      fi
      if [[ "$HOST_SET" == "true" ]]; then
        echo "Error: --host may only be specified once" >&2
        usage >&2
        exit 1
      fi
      HOST="$2"
      HOST_SET=true
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Error: unrecognized argument '$1'" >&2
      usage >&2
      exit 1
      ;;
  esac
done

SYSTEM="$(uname -s)"
case "$SYSTEM" in
  Darwin)
    PLATFORM="darwin"
    ;;
  Linux)
    if [[ -f /etc/NIXOS ]]; then
      PLATFORM="nixos"
    else
      echo "Error: Linux is not a supported NixOS rebuild host" >&2
      exit 1
    fi
    ;;
  *)
    echo "Error: unsupported operating system '$SYSTEM'" >&2
    exit 1
    ;;
esac

if [[ "$HOST_SET" != "true" ]]; then
  CURRENT_HOST="$(hostname)"
  HOST="${CURRENT_HOST%%.*}"
fi

case "$HOST" in
  lhs-desktop)
    HOST_PLATFORM="nixos"
    ;;
  lhs-mbp|mac-mini)
    HOST_PLATFORM="darwin"
    ;;
  *)
    echo "Error: unsupported host '$HOST'; choose lhs-desktop, lhs-mbp, or mac-mini" >&2
    exit 1
    ;;
esac

if [[ "$HOST_PLATFORM" != "$PLATFORM" ]]; then
  echo "Error: host '$HOST' is a $HOST_PLATFORM target and cannot be rebuilt on $SYSTEM" >&2
  exit 1
fi

# Refuse to include files that are outside the tracked configuration history.
if [ -n "$(git ls-files --others --exclude-standard)" ]; then
  echo "Error: untracked files exist. Move or remove them before rebuilding."
  exit 1
fi

if ! git diff --quiet; then
  echo "Error: unstaged tracked changes exist. Stage or discard them before rebuilding."
  exit 1
fi

if git diff --cached --quiet; then
  echo "Error: no staged changes. Stage the configuration files to deploy with git add before rebuilding."
  exit 1
fi

if [ "$UPDATE_SECRET" = "true" ]; then
  nix flake update secrets
  if ! git diff --quiet; then
    echo "Error: unstaged tracked changes exist after updating secrets. Stage them and rerun the rebuild."
    exit 1
  fi
fi

# Rebuild
if [[ "$PLATFORM" == "darwin" ]]; then
  if sudo darwin-rebuild switch --flake ".#$HOST"; then
    gen=$(sudo darwin-rebuild --list-generations | grep current | awk '{print $1}')
    git commit -m "$HOSTNAME OSX Generation $gen: $(date +'%Y-%m-%d %H:%M:%S')"
    git push origin main
    echo "$HOSTNAME rebuilt - gen $gen"
  else
    echo "Build Failed. Fix the errors above. Nothing was committed"
    exit 1
  fi
elif [[ "$PLATFORM" == "nixos" ]]; then
  if sudo nixos-rebuild switch --flake ".#$HOST"; then
    # Commit the changes
    gen=$(nixos-rebuild list-generations | grep True | awk '{print $1}')
    git commit -m "$HOSTNAME NixOs Generation $gen: $(date +'%Y-%m-%d %H:%M:%S')"
    git push origin main

    echo "$HOSTNAME rebuilt - gen $gen"
  else
    echo "Build Failed. Fix the errors above. Nothing was committed"
    exit 1
  fi
fi
