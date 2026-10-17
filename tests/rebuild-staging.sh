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
  echo original > "$repo/unrelated.nix"
  git -C "$repo" add config.nix unrelated.nix
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
  [[ "${MOCK_REBUILD_FAIL:-}" != 1 ]]
  exit $?
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
  (cd "$repo" && PATH="$tmp/bin:$PATH" MOCK_STATE="$tmp" HOSTNAME=mac-mini bash "$script")
}

run_failed_rebuild() {
  local repo=$1
  (cd "$repo" && PATH="$tmp/bin:$PATH" MOCK_STATE="$tmp" MOCK_REBUILD_FAIL=1 HOSTNAME=mac-mini bash "$script")
}

# Untracked content must block deployment without changing the existing index.
repo=$(setup_repo untracked)
printf 'staged config\n' > "$repo/config.nix"
git -C "$repo" add config.nix
echo secret > "$repo/secret.txt"
if run_rebuild "$repo" > "$tmp/untracked.out" 2>&1; then
  fail 'untracked files should have blocked rebuild'
fi
grep -q 'untracked files exist' "$tmp/untracked.out" || fail 'missing untracked-file error'
[[ ! -e "$tmp/rebuild-ran" ]] || fail 'rebuild ran with untracked files present'
[[ "$(git -C "$repo" diff --cached --name-only)" == config.nix ]] || fail 'preflight changed the staged index'
[[ "$(git -C "$repo" ls-files --others --exclude-standard)" == secret.txt ]] || fail 'untracked file was changed or staged'

# An empty index must be rejected rather than creating a generation without history.
repo=$(setup_repo unstaged)
printf 'unstaged config\n' > "$repo/config.nix"
if run_rebuild "$repo" > "$tmp/unstaged.out" 2>&1; then
  fail 'unstaged changes should not have been deployed'
fi
grep -q 'no staged changes' "$tmp/unstaged.out" || fail 'missing empty-index error'
[[ ! -e "$tmp/rebuild-ran" ]] || fail 'rebuild ran with no staged changes'
[[ -z "$(git -C "$repo" diff --cached --name-only)" ]] || fail 'unstaged file was added to the index'

# Commit/push exactly the staged snapshot; unrelated tracked edits remain unstaged.
repo=$(setup_repo tracked)
printf 'deployed config\n' > "$repo/config.nix"
git -C "$repo" add config.nix
printf 'local unrelated edit\n' > "$repo/unrelated.nix"
run_rebuild "$repo" > "$tmp/tracked.out" 2>&1 || fail 'staged configuration rebuild failed'
[[ "$(git -C "$repo" show HEAD:config.nix)" == 'deployed config' ]] || fail 'staged edit was not committed'
[[ "$(git -C "$repo" show HEAD:unrelated.nix)" == original ]] || fail 'unstaged tracked edit was committed'
[[ "$(git --git-dir="$tmp/tracked-remote.git" show main:config.nix)" == 'deployed config' ]] || fail 'staged commit was not pushed to main'
[[ "$(git -C "$repo" status --porcelain)" == ' M unrelated.nix' ]] || fail 'unstaged tracked edit should remain untouched'

# A failed switch must leave the index uncommitted and the remote unchanged.
repo=$(setup_repo failed-switch)
printf 'staged config\n' > "$repo/config.nix"
git -C "$repo" add config.nix
if run_failed_rebuild "$repo" > "$tmp/failed-switch.out" 2>&1; then
  fail 'failed switch should have failed the rebuild workflow'
fi
[[ "$(git -C "$repo" rev-parse HEAD)" == "$(git -C "$repo" rev-parse origin/main)" ]] || fail 'failed switch created a local commit'
[[ -z "$(git --git-dir="$tmp/failed-switch-remote.git" rev-parse --verify refs/heads/main 2>/dev/null)" ]] && fail 'failed switch unexpectedly pushed a commit'
if git -C "$repo" diff --cached --quiet; then
  fail 'failed switch cleared the staged index'
fi
[[ "$(git -C "$repo" show :config.nix)" == 'staged config' ]] || fail 'failed switch changed staged content'

echo 'rebuild staging tests passed'
