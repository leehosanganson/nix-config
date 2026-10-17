{ pkgs, ... }: {
  nix = {
    settings.auto-optimise-store = true;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;

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
    docker-compose
  ];
}
