{ pkgs, ... }: {
  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="input", SYMLINK+="uinput"
  '';
  users.users.ansonlee.extraGroups = [ "input" ];

  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    libva
    libva-utils
  ];

  # mouse
  services.libinput.enable = true;
  services.libinput.mouse.accelProfile = "flat";
}
