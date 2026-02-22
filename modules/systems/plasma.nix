{ ... }: {
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  
  services.libinput.enable = true;
  services.libinput.mouse.accelProfile = "flat";

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
}
