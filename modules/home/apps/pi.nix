{ config, pkgs, ... }:

{
  home.packages = [ pkgs.pi-coding-agent ];

  home.file.".pi/agent".source = config.lib.file.mkOutOfStoreSymlink (
    "${config.home.homeDirectory}/nix-config/dotfiles/pi/agent"
  );
}
