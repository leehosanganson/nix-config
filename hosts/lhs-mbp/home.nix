{ ... }:

{
  home = {
    username = "ansonlee";
    homeDirectory = "/Users/ansonlee";
    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;

  imports = [
    ./sops.nix
    ../../modules/home/apps/dev.nix
    ../../modules/home/apps/syncthing.nix
    ../../modules/home/core
  ];
}
