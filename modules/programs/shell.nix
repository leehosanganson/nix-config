{ lib, pkgs, ... }: {
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

  home.activation = {
    installTpm = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
        ${pkgs.git}/bin/git clone https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm"
      fi
    '';
  };

  home.packages = with pkgs; [
    ghostty
    btop
    ripgrep
    fd
    lazygit
    zoxide
    fzf
    kubectl
    iftop
    unzip
    tmux
  ];
}
