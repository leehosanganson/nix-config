{ config, pkgs, ... }:

{
  home.username = "ansonlee";
  home.homeDirectory = "/home/ansonlee";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    # Compilers / Interpreters
    gcc
    zig
    nodejs
    python3
    rustc
    cargo

    # CLI Tools
    zoxide
    fzf
    kubectl
    lazygit
    fd
    ripgrep
    btop
    iftop
    unzip
    tmux

    # Neovim
    neovim
    lua-language-server
    stylua
    selene
    nil
    clang-tools
    rust-analyzer
    helm-ls
    dockerfile-language-server

    # Nix
    nixpkgs-fmt

    # Applciations
    ghostty
    google-chrome
    discord
    moonlight-qt
    bitwarden-desktop
    steam
  ];

  # Dotfiles
  home.file.".config/ghostty".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/ghostty/.config/ghostty";
  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/nvim/.config/nvim";
  home.file."tmux.conf".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/tmux/.config/tmux/tmux.conf";

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
