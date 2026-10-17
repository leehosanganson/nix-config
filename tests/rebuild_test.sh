#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT
MOCK_BIN="$TMP_DIR/bin"
mkdir -p "$MOCK_BIN"

cat > "$MOCK_BIN/uname" <<'MOCK'
#!/usr/bin/env bash
printf '%s\n' "${MOCK_UNAME:-Darwin}"
MOCK
cat > "$MOCK_BIN/hostname" <<'MOCK'
#!/usr/bin/env bash
printf '%s\n' "${MOCK_HOSTNAME:-mac-mini}"
MOCK
cat > "$MOCK_BIN/nix" <<'MOCK'
#!/usr/bin/env bash
printf 'nix' >> "$MOCK_LOG"
printf ' <%s>' "$@" >> "$MOCK_LOG"
printf '\n' >> "$MOCK_LOG"
MOCK
cat > "$MOCK_BIN/sudo" <<'MOCK'
#!/usr/bin/env bash
printf 'sudo' >> "$MOCK_LOG"
printf ' <%s>' "$@" >> "$MOCK_LOG"
printf '\n' >> "$MOCK_LOG"
if [[ "$1" == "darwin-rebuild" && "$2" == "--list-generations" ]]; then
  printf '12   current\n'
fi
MOCK
cat > "$MOCK_BIN/darwin-rebuild" <<'MOCK'
#!/usr/bin/env bash
printf 'darwin-rebuild' >> "$MOCK_LOG"
printf ' <%s>' "$@" >> "$MOCK_LOG"
printf '\n' >> "$MOCK_LOG"
MOCK
cat > "$MOCK_BIN/nixos-rebuild" <<'MOCK'
#!/usr/bin/env bash
printf 'nixos-rebuild' >> "$MOCK_LOG"
printf ' <%s>' "$@" >> "$MOCK_LOG"
printf '\n' >> "$MOCK_LOG"
if [[ "$1" == "list-generations" ]]; then
  printf '12   True\n'
fi
MOCK
cat > "$MOCK_BIN/git" <<'MOCK'
#!/usr/bin/env bash
printf 'git' >> "$MOCK_LOG"
printf ' <%s>' "$@" >> "$MOCK_LOG"
printf '\n' >> "$MOCK_LOG"
if [[ "$1 $2 $3" == "diff --cached --quiet" ]]; then
  exit 1
fi
MOCK
cat > "$MOCK_BIN/date" <<'MOCK'
#!/usr/bin/env bash
printf '2026-01-02 03:04:05\n'
MOCK
chmod +x "$MOCK_BIN"/*

run_rebuild() {
  local log="$1"
  shift
  MOCK_LOG="$log" PATH="$MOCK_BIN:$PATH" "$SCRIPT_DIR/rebuild.sh" "$@"
}

assert_contains() {
  local file="$1" expected="$2"
  if ! grep -Fq -- "$expected" "$file"; then
    printf 'Expected to find %q in %s\n' "$expected" "$file" >&2
    return 1
  fi
}

assert_not_contains() {
  local file="$1" unexpected="$2"
  if grep -Fq -- "$unexpected" "$file"; then
    printf 'Did not expect to find %q in %s\n' "$unexpected" "$file" >&2
    return 1
  fi
}

# An explicit target works regardless of the machine hostname, and update remains
# an extra step before the ordinary rebuild/commit/push workflow.
LOG="$TMP_DIR/explicit.log"
MOCK_UNAME=Darwin MOCK_HOSTNAME=unrelated run_rebuild "$LOG" --update-secrets --host mac-mini
assert_contains "$LOG" 'nix <flake> <update> <secrets>'
assert_contains "$LOG" 'sudo <darwin-rebuild> <switch> <--flake> <.#mac-mini>'
assert_contains "$LOG" 'git <push> <origin> <main>'

# Existing installations retain a hostname-based default when the hostname is
# one of the allowed flake outputs.
LOG="$TMP_DIR/default.log"
MOCK_UNAME=Darwin MOCK_HOSTNAME=lhs-mbp run_rebuild "$LOG"
assert_contains "$LOG" 'sudo <darwin-rebuild> <switch> <--flake> <.#lhs-mbp>'

# Linux uses the same allowlisted resolution and passes the selected flake target
# through the existing NixOS generation/commit/push path.
if [[ -f /etc/NIXOS ]]; then
  LOG="$TMP_DIR/linux.log"
  MOCK_UNAME=Linux MOCK_HOSTNAME=unrelated run_rebuild "$LOG" --host lhs-desktop
  assert_contains "$LOG" 'sudo <nixos-rebuild> <switch> <--flake> <.#lhs-desktop>'
  assert_contains "$LOG" 'git <push> <origin> <main>'
else
  echo 'Skipping Linux rebuild path: test environment is not NixOS'
fi

# Invalid and cross-platform targets fail before update, staging, or rebuild.
for args in '--host missing-host' '--host lhs-desktop'; do
  LOG="$TMP_DIR/error.log"
  : > "$LOG"
  if MOCK_UNAME=Darwin MOCK_HOSTNAME=unrelated run_rebuild "$LOG" --update-secrets $args >"$TMP_DIR/out" 2>&1; then
    echo "Expected '$args' to fail" >&2
    exit 1
  fi
  assert_not_contains "$LOG" 'nix '
  assert_not_contains "$LOG" 'git '
  assert_not_contains "$LOG" 'sudo '
done

# --update-secrets alone is not an update-only mode: hostname resolution fails
# before any update can run when no valid installed-host default exists.
LOG="$TMP_DIR/update-only.log"
: > "$LOG"
if MOCK_UNAME=Darwin MOCK_HOSTNAME=unrelated run_rebuild "$LOG" --update-secrets >"$TMP_DIR/out" 2>&1; then
  echo 'Expected update-only invocation without an installed host to fail' >&2
  exit 1
fi
assert_not_contains "$LOG" 'nix '

# Invalid argument forms and help are resolved before any side effect.
for args in '--host' '--host mac-mini --host lhs-mbp'; do
  LOG="$TMP_DIR/parse-error.log"
  : > "$LOG"
  if run_rebuild "$LOG" $args >"$TMP_DIR/out" 2>&1; then
    printf 'Expected malformed arguments %q to fail\n' "$args" >&2
    exit 1
  fi
  assert_not_contains "$LOG" 'git '
done
LOG="$TMP_DIR/help.log"
: > "$LOG"
run_rebuild "$LOG" --help >"$TMP_DIR/out"
grep -Fq -- '--host HOST' "$TMP_DIR/out"
assert_not_contains "$LOG" 'git '

echo 'rebuild.sh target tests passed'
