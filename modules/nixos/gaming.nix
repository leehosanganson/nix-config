_: {
  services = {
    udev.extraRules = ''
      # 2.4GHz/Dongle
      KERNEL=="hidraw*", ATTRS{idProduct}=="2dc8", MODE="0660", TAG+="uaccess"

      # Bluetooth
      KERNEL=="hidraw*", KERNELS=="*2DC8:*", MODE="0660", TAG+="uaccess"
    '';
    libinput = {
      enable = true;
      mouse.accelProfile = "flat";
    };
  };

  users.users.ansonlee.extraGroups = [ "input" ];

}
