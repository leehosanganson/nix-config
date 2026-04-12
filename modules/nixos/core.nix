{ pkgs, ... }: {
  # Nix
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # User
  users.users.ansonlee = {
    isNormalUser = true;
    description = "Anson Lee";
    extraGroups = [ "networkmanager" "wheel" "podman" ];
    shell = pkgs.zsh;
  };

  # Configure printers
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
}
