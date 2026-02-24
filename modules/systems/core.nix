{ pkgs, ... }: {
  # Nix
  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    settings.auto-optimise-store = true;

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs.config.allowUnfree = true;

  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.ansonlee = {
    isNormalUser = true;
    description = "Anson Lee";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
    TERMINAL = "ghostty";
    TERM = "ghostty";
    BROWSER = "zen";
  };

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
