# Nix configuration

This repository configures three hosts through `flake.nix`:

| Flake target | Platform | Configuration |
| --- | --- | --- |
| `nixosConfigurations.lhs-desktop` | `x86_64-linux` | NixOS desktop |
| `darwinConfigurations.lhs-mbp` | `aarch64-darwin` | MacBook Pro |
| `darwinConfigurations.mac-mini` | `aarch64-darwin` | Mac mini |

## Prerequisites

- Install Nix with flakes enabled. The shared configuration enables the `nix-command` and `flakes` experimental features.
- The `secrets` flake input is a private GitHub repository fetched using SSH (`git@github.com:leehosanganson/sops.git`). Ensure your SSH key has access before evaluating or building a flake target.
- The hosts' SOPS configuration reads `secrets.yaml` from that input and expects an age key at `~/.config/sops/age/keys.txt` for the configured user. Have the appropriate key on the target machine before switching.
- `.gitmodules` also declares the private `dotfiles` submodule over SSH. Initialize it when you need its contents: `git submodule update --init --recursive`. It is separate from the `secrets` flake input.

## Evaluate, build, and activate

Evaluation checks the flake and resolves a derivation; it does not build or activate it. `nix build` builds the closure but leaves the running system unchanged. `switch` builds as needed and activates the configuration on the current machine, requiring the matching platform and appropriate privileges.

The `nix eval` commands resolve each target's derivation and can be run without activating it. Run `nix build` on the matching platform or with a suitable remote builder:

```sh
# NixOS, x86_64-linux
nix eval --raw .#nixosConfigurations.lhs-desktop.config.system.build.toplevel.drvPath
nix build .#nixosConfigurations.lhs-desktop.config.system.build.toplevel

# nix-darwin, aarch64-darwin
nix eval --raw .#darwinConfigurations.lhs-mbp.system.drvPath
nix build .#darwinConfigurations.lhs-mbp.system
nix eval --raw .#darwinConfigurations.mac-mini.system.drvPath
nix build .#darwinConfigurations.mac-mini.system
```

To activate directly, use the matching target explicitly:

```sh
sudo nixos-rebuild switch --flake .#lhs-desktop
sudo darwin-rebuild switch --flake .#lhs-mbp
sudo darwin-rebuild switch --flake .#mac-mini
```

The NixOS target is Linux-only, and both Darwin targets are configured for Apple Silicon (`aarch64-darwin`). This checkout's host is Linux, so it cannot locally build or activate the Darwin configurations without an appropriate Darwin builder; likewise, the Darwin targets cannot be activated from Linux. Build on a matching machine (or configure a suitable remote builder). The desktop configuration also includes machine-specific hardware settings.

## `rebuild.sh`

On its intended host, `./rebuild.sh` switches the configuration selected by the machine's `hostname`. After a successful switch, it records the active generation in a Git commit and pushes that commit to `origin main`. Use `./rebuild.sh --update-secrets` to update the `secrets` flake input before switching (the flag works on either OS).

**Caution:** the script currently runs `git add .` before attempting the switch. That stages every change and untracked file under the repository, not just configuration or generation history; review `git status` and ensure there is nothing sensitive or unrelated in the working tree before running it. The script is intended for a clean, correctly targeted host checkout with permission to push to `origin main`. It does not make a commit or push if the switch fails.
