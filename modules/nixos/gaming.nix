{ pkgs, ... }: {
  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="input", SYMLINK+="uinput"
  '';
  users.users.ansonlee.extraGroups = [ "input" ];

  # mouse
  services.libinput.enable = true;
  services.libinput.mouse.accelProfile = "flat";
}
