# Build validation

## GitHub Actions

The Build validation workflow runs without repository secrets or access to the
private `secrets` flake input. It parses every Git-tracked `.nix` file with
`nix-instantiate --parse` and checks Git-tracked `.sh` files with `bash -n`.
It does not evaluate or build the flake, fetch SOPS data, or claim that any host
system was built.

## Local pre-commit checks

Enable the versioned hook in this checkout with:

```sh
git config core.hooksPath .githooks
```

The hook runs the same Nix syntax and shell syntax checks as CI. It requires
`git`, `nix-instantiate`, and `bash` on `PATH`. It uses no hook framework, does
not evaluate the flake, and does not fetch SOPS or
the private `secrets` input. The hook checks files known to Git, including
staged and unstaged tracked files; newly added untracked files are checked after
they have been added to Git's index.

Hooks are local and bypassable (for example, with
`git -c core.hooksPath=/dev/null commit`). They are a convenience, not a security
boundary. Full local host evaluation/builds remain separate operations and
require access to the private `secrets` flake input; this lightweight CI and
hook do not validate host builds.
