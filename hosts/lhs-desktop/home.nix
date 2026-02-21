{ config, pkgs, ... }:

{
  home.username = "ansonlee";
  home.homeDirectory = "/home/ansonlee";

  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    # Compilers / Interpreters
    gcc
    zig
    nodejs
    python3

    # CLI Tools
    zoxide
    fzf
    kubectl

    # Neovim
    neovim
    ripgrep
    fd
    lua-language-server
    lazygit

    # Nix
    nil
    nixpkgs-fmt

    # Applciations
    ghostty
    waybar
    rofi
    dunst
    libnotify
  ];

  # Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = ",preferred,auto,1";
      general = {
        gaps_in = 5;
        gaps_out = 10;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
      };
      decoration = {
        rounding = 10;
        drop_shadow = "yes";
        shadow_range = 4;
      };
    };
  };

  # Shell
  programs.bash.shellAliases = {
    rebuild = "bash ~/nix-config/rebuild.sh";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
    };
    initContent = ''
      source ~/.config/zsh/config
    '';
  };


  programs.home-manager.enable = true;
}
