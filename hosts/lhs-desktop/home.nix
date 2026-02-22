{ config, pkgs, ... }:

{
  home.username = "ansonlee";
  home.homeDirectory = "/home/ansonlee";
  home.stateVersion = "25.11";

  home.packages = with pkgs;
    [
      # Compilers / Interpreters
      gcc
      zig
      nodejs
      python3

      # CLI Tools
      zoxide
      fzf
      kubectl
      lazygit
      fd
      ripgrep

      # Neovim
      neovim
      lua-language-server

      # Nix
      nil
      nixpkgs-fmt

      # Applciations
      ghostty
      google-chrome
      discord
      moonlight-qt
      bitwarden-desktop
      steam
    ];

  # Shell
  programs.bash.shellAliases = {
    rebuild = "bash ~/nixos-config/rebuild.sh";
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
