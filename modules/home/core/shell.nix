{ pkgs, dotfilesPath, ... }: {
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
  };


  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      cpu
      catppuccin
      vim-tmux-navigator
    ];
    extraConfig = builtins.readFile "${dotfilesPath}/tmux/.config/tmux/tmux.base.conf";
  };


  home.packages = with pkgs; [
    ripgrep
    lazygit
    zoxide
    fastfetch
  ];
}
