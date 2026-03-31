{ pkgs, ... }: {
  programs.git = {
    enable = true;
    settings = {
      user.name = "Anson Lee";
      user.email = "leehosanganson@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = false;
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
  ];
}
