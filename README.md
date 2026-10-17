# Nix configuration

Nix flake for three hosts:

| Host | System | Flake target |
| --- | --- | --- |
| `lhs-desktop` | NixOS, `x86_64-linux` | `nixosConfigurations.lhs-desktop` |
| `lhs-mbp` | macOS, `aarch64-darwin` | `darwinConfigurations.lhs-mbp` |
| `mac-mini` | macOS, `aarch64-darwin` | `darwinConfigurations.mac-mini` |

## Requirements

Install Nix with flakes enabled. Evaluation also requires SSH access to the private `secrets` input. Switching requires the configured age key at `~/.config/sops/age/keys.txt`.

## Build and switch

Build a target on its matching platform (or with a suitable remote builder):

```sh
nix build .#nixosConfigurations.lhs-desktop.config.system.build.toplevel
nix build .#darwinConfigurations.lhs-mbp.system
nix build .#darwinConfigurations.mac-mini.system
```

Switch a configuration directly with `nixos-rebuild` or `darwin-rebuild`, for example:

```sh
sudo nixos-rebuild switch --flake .#lhs-desktop
sudo darwin-rebuild switch --flake .#lhs-mbp
sudo darwin-rebuild switch --flake .#mac-mini
```

## `rebuild.sh`

Run `./rebuild.sh` on the target host. It selects the flake target from the machine hostname and the rebuild command from the operating system. The hostname must match a target listed above.

The script stages **all** changes with `git add .`, switches the system, then commits the staged changes and pushes to `origin main`. A failed switch is not committed or pushed. Use `./rebuild.sh --update-secrets` to update the `secrets` flake input before switching; any resulting changes are included in the staged commit.

For syntax checks and CI details, see [Build validation](docs/build-validation.md).
