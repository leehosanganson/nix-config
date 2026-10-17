{ ... }:
{
  system.stateVersion = 6;
  nix.enable = false;
  nixpkgs.hostPlatform = "aarch64-darwin";

  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
    TERM = "xterm-256color";
  };

  services.openssh = {
    enable = true;
    extraConfig = ''
      PermitRootLogin no
      PasswordAuthentication no
    '';
  };

  users.users.ansonlee = {
    description = "Anson Lee";
    home = "/Users/ansonlee";
  };

  services.tailscale.enable = true;
}
