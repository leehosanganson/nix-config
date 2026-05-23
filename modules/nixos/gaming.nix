_: {
  services.udev.extraRules = ''
    # 2.4GHz/Dongle
    KERNEL=="hidraw*", ATTRS{idProduct}=="6012", ATTRS{idVendor}=="2dc8", MODE="0660", TAG+="uaccess", GROUP="input"

    # Bluetooth
    KERNEL=="hidraw*", KERNELS=="*2DC8:6012*", MODE="0660", TAG+="uaccess", GROUP="input"
  '';

  users.users.ansonlee.extraGroups = [ "input" ];

  # mouse
  services.libinput.enable = true;
  services.libinput.mouse.accelProfile = "flat";
}
