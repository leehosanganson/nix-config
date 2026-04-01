{ self, pkgs, ... }: {
  # Nix
  nix = {
    settings.auto-optimise-store = true;
    settings.experimental-features = [ "nix-command" "flakes" ];
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
    jack.enable = true;
    wireplumber.enable = true;
  };

  programs.zsh.enable = true;

  users.users.ansonlee = {
    isNormalUser = true;
    description = "Anson Lee";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
    TERMINAL = "ghostty";
    TERM = "xterm-256color";
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
