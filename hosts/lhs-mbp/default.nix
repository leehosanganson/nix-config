{ ... }:
{
  networking.hostName = "lhs-mbp";
  system.primaryUser = "ansonlee";
  environment.variables.TERMINAL = "ghostty";

  imports = [
    ../../modules/common.nix
    ../../modules/darwin/common.nix
    ../../modules/ssh/authorized-keys.nix
  ];

  homebrew = {
    enable = true;
    onActivation = {
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
      "vlc"
      "aerospace"
      "ghostty"
      "linearmouse"
      "orbstack"
      "rectangle"
    ];
  };
}
