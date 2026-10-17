{ pkgs, ... }: {
  # Nix
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    optimise = {
      automatic = true;
      dates = [ "03:45" ];
    };
  };

  # User
  users.users.ansonlee = {
    isNormalUser = true;
    description = "Anson Lee";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
  };

  # Configure printers and audio.
  services = {
    printing.enable = true;
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
  };

  # Default fonts
  fonts = {
    enableDefaultPackages = true;
    fontconfig.enable = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.hack
      nerd-fonts.fira-code
      nerd-fonts._0xproto
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];
  };

  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
    TERMINAL = "ghostty";
    TERM = "xterm-256color";
    BROWSER = "zen";
  };

  environment.systemPackages = with pkgs; [ xdg-utils ];

  security.rtkit.enable = true;
}
