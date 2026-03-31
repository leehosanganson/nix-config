{ pkgs, ... }: {
  programs.git = {
    enable = true;
    userName = "Anson Lee";
    userEmail = "leehosanganson@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;

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
  ];
}
