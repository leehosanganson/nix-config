{ ... }:
{
  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";
  nix.enable = false;
  networking.hostName = "lhs-mbp";

  imports = [
    ../../modules/common.nix
  ];

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

  homebrew = {
    enable = true;
    casks = [
      "aerospace"
      "ghostty"
      "mos"
      "orbstack"
      "rectangle"
    ];
  };
}
