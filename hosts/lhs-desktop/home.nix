{ pkgs, inputs, ... }:

{
  programs.home-manager.enable = true;
  home = {
    username = "ansonlee";
    stateVersion = "25.11";
    homeDirectory = "/home/ansonlee";
  };

  imports = [
    ../../modules/home/core
    ./variables.nix
    ./sops.nix

    # Applications
    ../../modules/home/apps/yazi.nix
    ../../modules/home/apps/dev.nix
    ../../modules/home/apps/k8s.nix
    ../../modules/home/apps/syncthing.nix

    # Desktop
    ../../modules/home/desktop/hyprland
    ../../modules/home/gui/hyprland-gui.nix
  ];

  # Applications
  home.packages = with pkgs; [
    ghostty
    google-chrome
    discord
    obsidian
    (symlinkJoin {
      name = "moonlight-fix";
      paths = [ moonlight-qt ];
      buildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/moonlight \
          --set FORCE_VAAPI 1
      '';
    })
    bitwarden-desktop
    steam
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    pear-desktop
    feishin
    devpod
    github-copilot-cli
    runelite
    zathura
    vlc
  ];
}
