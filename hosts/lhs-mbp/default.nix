{ ... }:
{
  system.stateVersion = 6;
  nix.enable = false;
  nixpkgs.hostPlatform = "aarch64-darwin";
  networking.hostName = "lhs-mbp";
  system.primaryUser = "ansonlee";

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
    onActivation = {
      cleanup = "zap";
      upgrade = true;
      autoUpdate = true;
    };
    taps = [
      "nikitabobko/tap"
    ];
    brews = [
      "mas"
      "fontconfig"
    ];
    casks = [
      "aerospace"
      "ghostty"
      "mos"
      "orbstack"
      "rectangle"
    ];
  };
}
