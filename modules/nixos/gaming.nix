_: {
  services.udev.extraRules = ''
    # 2.4GHz/Dongle
    KERNEL=="hidraw*", ATTRS{idProduct}=="2dc8", MODE="0660", TAG+="uaccess"

    # Bluetooth
    KERNEL=="hidraw*", KERNELS=="*2DC8:*", MODE="0660", TAG+="uaccess"
  '';

  users.users.ansonlee.extraGroups = [ "input" ];

  # mouse
  services.libinput.enable = true;
  services.libinput.mouse.accelProfile = "flat";
}
