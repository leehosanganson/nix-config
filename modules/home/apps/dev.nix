{ pkgs, ... }: {
  programs.git = {
    enable = true;
    signing.format = "ssh";
    settings = {
      user.name = "Anson Lee";
      user.email = "leehosanganson@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = false;
        fetch.prune = true;
      };
    };
  };

  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
    TERM = "xterm-256color";
  };

  home.packages = with pkgs; [
    vim
    wget
    git
    fd
    fzf
    curl
    jq
    tmux
    gh
    tldr
    opencode
  ];
}
