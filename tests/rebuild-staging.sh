#!/usr/bin/env bash
set -euo pipefail

script=$(cd "$(dirname "$0")/.." && pwd)/rebuild.sh
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

setup_repo() {
  local name=$1
  local repo="$tmp/$name"
  mkdir -p "$repo" "$tmp/bin"
  git init -q --bare "$tmp/$name-remote.git"
  git -C "$repo" init -q -b main
  git -C "$repo" config user.name Test
  git -C "$repo" config user.email test@example.com
  echo original > "$repo/config.nix"
  git -C "$repo" add config.nix
  git -C "$repo" commit -qm initial
  git -C "$repo" remote add origin "$tmp/$name-remote.git"
  git -C "$repo" push -qu origin main
  git -C "$repo" config branch.main.remote origin
  git -C "$repo" config branch.main.merge refs/heads/main
  printf '%s\n' '#!/usr/bin/env bash' 'echo Darwin' > "$tmp/bin/uname"
  cat > "$tmp/bin/sudo" <<'MOCK'
#!/usr/bin/env bash
if [[ "$1 $2" == "darwin-rebuild switch" ]]; then
  touch "$MOCK_STATE/rebuild-ran"
  exit 0
fi
if [[ "$1 $2" == "darwin-rebuild --list-generations" ]]; then
  echo '1 current'
  exit 0
fi
exit 1
MOCK
  chmod +x "$tmp/bin/uname" "$tmp/bin/sudo"
  printf '%s\n' "$repo"
}

run_rebuild() {
  local repo=$1
  (cd "$repo" && PATH="$tmp/bin:$PATH" MOCK_STATE="$tmp" HOSTNAME=test-host bash "$script")
}

# Untracked content must block deployment before the rebuild can run.
repo=$(setup_repo untracked)
echo secret > "$repo/secret.txt"
if run_rebuild "$repo" > "$tmp/untracked.out" 2>&1; then
  fail 'untracked files should have blocked rebuild'
fi
grep -q 'untracked files exist' "$tmp/untracked.out" || fail 'missing untracked-file error'
[[ ! -e "$tmp/rebuild-ran" ]] || fail 'rebuild ran with untracked files present'
[[ -z "$(git -C "$repo" status --porcelain | grep '^A' || true)" ]] || fail 'untracked file was staged'

# Existing staged changes must be left untouched and block deployment.
repo=$(setup_repo staged)
echo staged > "$repo/config.nix"
git -C "$repo" add config.nix
if run_rebuild "$repo" > "$tmp/staged.out" 2>&1; then
  fail 'pre-staged changes should have blocked rebuild'
fi
grep -q 'staged changes exist' "$tmp/staged.out" || fail 'missing staged-change error'
[[ ! -e "$tmp/rebuild-ran" ]] || fail 'rebuild ran with staged changes present'

# Tracked configuration edits should be committed and pushed after a successful switch.
repo=$(setup_repo tracked)
printf 'deployed config\n' > "$repo/config.nix"
run_rebuild "$repo" > "$tmp/tracked.out" 2>&1 || fail 'tracked configuration rebuild failed'
[[ "$(git -C "$repo" show HEAD:config.nix)" == 'deployed config' ]] || fail 'tracked edit was not committed'
[[ "$(git --git-dir="$tmp/tracked-remote.git" show main:config.nix)" == 'deployed config' ]] || fail 'commit was not pushed to main'
[[ -z "$(git -C "$repo" status --porcelain)" ]] || fail 'working tree should be clean after commit'

echo 'rebuild staging tests passed'
