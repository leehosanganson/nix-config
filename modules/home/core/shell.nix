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
      TPM_PATH="$HOME/.config/tmux/plugins/tpm"
      TMUX_CONF="$HOME/.config/tmux/tmux.conf"
       
      # 1. Ensure TPM exists
      if [ ! -d "$TPM_PATH" ]; then
        ${pkgs.git}/bin/git clone https://github.com/tmux-plugins/tpm "$TPM_PATH"
      fi

      # 2. Run installer with tmux in the PATH
      # We add pkgs.tmux and pkgs.git to the PATH just for this execution
      export PATH="${pkgs.tmux}/bin:${pkgs.git}/bin:$PATH"
       
      # We point directly to your config file to bypass auto-discovery issues
      TMUX_CONF="$TMUX_CONF" $TPM_PATH/bin/install_plugins
    '';
  };

  home.packages = with pkgs; [
    ghostty
    ripgrep
    lazygit
    zoxide
    kubectl
    tmux
  ];
}
