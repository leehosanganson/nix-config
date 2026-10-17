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
  echo original > "$repo/flake.lock"
  git -C "$repo" add config.nix unrelated.nix flake.lock
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
  cat > "$tmp/bin/nix" <<'MOCK'
#!/usr/bin/env bash
[[ "$*" == 'flake update secrets' ]] || exit 1
if [[ "${MOCK_UPDATE_LOCK:-}" == 1 ]]; then
  echo updated > flake.lock
fi
MOCK
  chmod +x "$tmp/bin/uname" "$tmp/bin/sudo" "$tmp/bin/nix"
  printf '%s\n' "$repo"
}

run_rebuild() {
  local repo=$1
  rm -f "$tmp/rebuild-ran"
  (cd "$repo" && PATH="$tmp/bin:$PATH" MOCK_STATE="$tmp" HOSTNAME=mac-mini bash "$script")
}

run_failed_rebuild() {
  local repo=$1
  rm -f "$tmp/rebuild-ran"
  (cd "$repo" && PATH="$tmp/bin:$PATH" MOCK_STATE="$tmp" MOCK_REBUILD_FAIL=1 HOSTNAME=mac-mini bash "$script")
}

run_update_secrets() {
  local repo=$1
  local update_lock=${2:-0}
  rm -f "$tmp/rebuild-ran"
  (cd "$repo" && PATH="$tmp/bin:$PATH" MOCK_STATE="$tmp" MOCK_UPDATE_LOCK="$update_lock" HOSTNAME=mac-mini bash "$script" --update-secrets)
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

# Unstaged tracked edits must block deployment even when staged changes exist.
repo=$(setup_repo unstaged-tracked)
printf 'staged config\n' > "$repo/config.nix"
git -C "$repo" add config.nix
printf 'unstaged unrelated edit\n' > "$repo/unrelated.nix"
if run_rebuild "$repo" > "$tmp/unstaged-tracked.out" 2>&1; then
  fail 'unstaged tracked changes should have blocked rebuild'
fi
grep -q 'unstaged tracked changes exist' "$tmp/unstaged-tracked.out" || fail 'missing unstaged tracked-file error'
[[ ! -e "$tmp/rebuild-ran" ]] || fail 'rebuild ran with unstaged tracked changes'
[[ "$(git -C "$repo" diff --cached --name-only)" == config.nix ]] || fail 'preflight changed staged content'
[[ "$(git -C "$repo" diff --name-only)" == unrelated.nix ]] || fail 'unstaged tracked edit was changed'

# A clean empty index must be rejected rather than creating a generation without history.
repo=$(setup_repo empty-index)
if run_rebuild "$repo" > "$tmp/empty-index.out" 2>&1; then
  fail 'an empty index should have blocked rebuild'
fi
grep -q 'no staged changes' "$tmp/empty-index.out" || fail 'missing empty-index error'
[[ ! -e "$tmp/rebuild-ran" ]] || fail 'rebuild ran with no staged changes'

# A staged snapshot is deployable and is exactly what gets committed and pushed.
repo=$(setup_repo staged)
printf 'deployed config\n' > "$repo/config.nix"
git -C "$repo" add config.nix
run_rebuild "$repo" > "$tmp/staged.out" 2>&1 || fail 'staged configuration rebuild failed'
[[ "$(git -C "$repo" show HEAD:config.nix)" == 'deployed config' ]] || fail 'staged edit was not committed'
[[ "$(git -C "$repo" show HEAD:unrelated.nix)" == original ]] || fail 'unchanged tracked file changed in commit'
[[ "$(git --git-dir="$tmp/staged-remote.git" show main:config.nix)" == 'deployed config' ]] || fail 'staged commit was not pushed to main'

# A failed switch must leave the index uncommitted and the remote unchanged.
repo=$(setup_repo failed-switch)
initial_remote_hash=$(git -C "$repo" rev-parse refs/remotes/origin/main)
printf 'staged config\n' > "$repo/config.nix"
git -C "$repo" add config.nix
if run_failed_rebuild "$repo" > "$tmp/failed-switch.out" 2>&1; then
  fail 'failed switch should have failed the rebuild workflow'
fi
[[ "$(git -C "$repo" rev-parse HEAD)" == "$initial_remote_hash" ]] || fail 'failed switch created a local commit'
[[ "$(git --git-dir="$tmp/failed-switch-remote.git" rev-parse refs/heads/main)" == "$initial_remote_hash" ]] || fail 'failed switch changed remote main'
if git -C "$repo" diff --cached --quiet; then
  fail 'failed switch cleared the staged index'
fi
[[ "$(git -C "$repo" show :config.nix)" == 'staged config' ]] || fail 'failed switch changed staged content'

# Updating secrets may write flake.lock; never rebuild until that change is staged.
repo=$(setup_repo update-lock)
printf 'staged config\n' > "$repo/config.nix"
git -C "$repo" add config.nix
if run_update_secrets "$repo" 1 > "$tmp/update-lock.out" 2>&1; then
  fail 'unstaged secrets lock update should have blocked rebuild'
fi
grep -q 'unstaged tracked changes exist after updating secrets' "$tmp/update-lock.out" || fail 'missing post-update staging error'
[[ ! -e "$tmp/rebuild-ran" ]] || fail 'rebuild ran with updated but unstaged flake.lock'
[[ "$(git -C "$repo" show HEAD:flake.lock)" == original ]] || fail 'secrets update was committed unexpectedly'
[[ "$(git -C "$repo" show :flake.lock)" == original ]] || fail 'secrets update was added to the index unexpectedly'
[[ "$(git -C "$repo" diff -- flake.lock)" == *'updated'* ]] || fail 'mock secrets update did not change flake.lock'

# After staging the lock update, a no-op update can rebuild and commit both staged files.
git -C "$repo" add flake.lock
run_update_secrets "$repo" 0 > "$tmp/update-lock-staged.out" 2>&1 || fail 'staged secrets lock update failed to rebuild'
[[ "$(git -C "$repo" show HEAD:config.nix)" == 'staged config' ]] || fail 'staged config was not committed after secrets update'
[[ "$(git -C "$repo" show HEAD:flake.lock)" == updated ]] || fail 'staged flake.lock update was not committed'
[[ "$(git --git-dir="$tmp/update-lock-remote.git" show main:flake.lock)" == updated ]] || fail 'staged flake.lock update was not pushed'

echo 'rebuild staging tests passed'
