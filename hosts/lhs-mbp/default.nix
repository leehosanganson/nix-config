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
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICZCH1vjRkNiw4b8btoOqd9WdPrN3lRc1lCrF3fWzfb+ leehosanganson@gmail.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFOuRvc3yYsvjGSLlvtiSTGYx8YscOGAxuLoQEgP/llb leehosanganson@gmail.com"
    ];
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
