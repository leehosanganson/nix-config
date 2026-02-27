{ pkgs, ... }: {
  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="input", SYMLINK+="uinput"
  '';

  users.users.ansonlee.extraGroups = [ "input" ];

  environment.systemPackages = with pkgs; [
    libva
  ];
  programs.gamemode.enable = true;

  hardware.graphics = {
    extraPackages = with pkgs; [
      libva-utils
      vulkan-loader
      vulkan-validation-layers
    ];
  };
}
