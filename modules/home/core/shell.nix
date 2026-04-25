{ pkgs, ... }: {
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
      function rebuild { (cd ~/nix-config && ~/nix-config/rebuild.sh "$@") }
      source ~/.config/zsh/config
      fastfetch
    '';
    loginExtra = ''
      if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = "1" ]; then
        exec start-hyprland
      fi
    '';
  };


  programs.tmux = {
    enable = true;
    sensibleOnTop = false;
    terminal = "tmux-256color";
    baseIndex = 1;
    keyMode = "vi";
    mouse = true;
    escapeTime = 0;
    historyLimit = 4000;
    plugins = with pkgs.tmuxPlugins; [
      cpu
      catppuccin
      vim-tmux-navigator
      resurrect
      continuum
    ];
  };


  home.packages = with pkgs; [
    stow
    ripgrep
    lazygit
    zoxide
    fastfetch
  ];
}
