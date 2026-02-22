{ pkgs, ...}: {
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

  home.packages = with pkgs; [
    ghostty
    tmux
    btop
    ripgrep
    fd
    lazygit
    zoxide
    fzf
    kubectl
    iftop
    unzip
  ];
}
