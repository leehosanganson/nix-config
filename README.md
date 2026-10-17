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

Run `./rebuild.sh` on the intended host to switch its configuration. By default, the script uses the machine's hostname (without any domain suffix); it accepts only `lhs-desktop`, `lhs-mbp`, and `mac-mini`. You can select one explicitly with `--host`, for example:

```sh
./rebuild.sh --host lhs-desktop
./rebuild.sh --host lhs-mbp
./rebuild.sh --host mac-mini
```

The selected host must match the machine's operating system: `lhs-desktop` requires NixOS, while `lhs-mbp` and `mac-mini` require macOS. Run `./rebuild.sh --help` for the available options.

Before running the script, use `git add <path>` for each tracked configuration file you intend to deploy (for example, `git add hosts/lhs-desktop/default.nix`). The script does not stage files for you: it rejects unstaged tracked edits, untracked files, and an empty staging area. Only the staged changes are committed after a successful switch. Afterward, it pushes that commit to `origin main`; the checkout therefore needs permission to push there. A failed switch is not committed or pushed.

Use `./rebuild.sh --update-secrets` to update the `secrets` flake input before switching (on either OS). If this changes `flake.lock`, the script stops because the lockfile update is unstaged. Stage the intended lockfile change with `git add flake.lock`, then rerun `./rebuild.sh` to rebuild and commit the staged changes.
