_: {
  services.desktopManager.plasma6.enable = true;

  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };
  services.displayManager.sddm.enable = true;

  services.libinput.enable = true;
  services.libinput.mouse.accelProfile = "flat";
}
