{ pkgs, ... }: {
  nix = {
    settings.auto-optimise-store = true;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;

  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
    TERMINAL = "ghostty";
    TERM = "xterm-256color";
    BROWSER = "zen";
  };

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack
    nerd-fonts.fira-code
    nerd-fonts._0xproto
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  # Apps
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    fd
    fzf
    gcc
    file
    git-ignore
    xdg-utils
    curl
    gnupg
    openssl
    jq
    go
    comma
    zip
    unzip
    pfetch
    unrar
    btop
    iftop
    nodejs
    python3
    cargo
  ];
}
