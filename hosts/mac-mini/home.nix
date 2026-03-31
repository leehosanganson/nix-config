{ ... }:

{
  home.username = "ansonlee";
  home.homeDirectory = "/Users/ansonlee";

  # Do not change
  home.stateVersion = "23.11";

  programs.home-manager.enable = true;

  imports = [
    ./sops.nix
  ];
}
