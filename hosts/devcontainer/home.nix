{ config, ... }:

{
  home.username = "vscode";
  home.homeDirectory = "/home/vscode";

  # Do not change
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  imports = [
    ./sops.nix
    ../../modules/home/core
    ../../modules/home/apps/dev.nix
  ];

  # Run sops-nix without systemd
  home.activation.setupSops = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    if ! systemctl --user is-system-running >/dev/null 2>&1; then
      echo "systemd not detected: Manually invoking sops-nix decryption..."
      
      SOPS_RUNTIME_DIR="/tmp/xdg-runtime-$(id -u)"
      mkdir -p "$SOPS_RUNTIME_DIR"
      chmod 700 "$SOPS_RUNTIME_DIR"

      XDG_RUNTIME_DIR="$SOPS_RUNTIME_DIR" $DRY_RUN_CMD ${toString config.systemd.user.services.sops-nix.Service.ExecStart}
    fi
  '';
}
