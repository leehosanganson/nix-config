# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  system.stateVersion = "25.11";

  imports =
    [
      ./variables.nix
      ../../modules/nixos/sddm.nix
      ../../modules/nixos/fonts.nix

      # Choose one
      # ../../modules/nixos/plasma.nix
      ../../modules/nixos/hyprland.nix

      # Don't change
      ../../modules/nixos/core.nix
      ./hardware-configuration.nix
    ];

  # Bootloader
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };

    extraModprobeConfig = ''
      options iwlwifi power_save=0
      options iwlmvm power_scheme=1
      options usbhid mousepoll=2
    '';

    kernelPackages = pkgs.linuxPackages_latest;

    kernelModules = [
      "thunderbolt"
      "usb4"
      "amdgpu"
    ];

    initrd = {
      kernelModules = [ "amdgpu" ];
      verbose = false;
    };

    kernelParams = [
      "vga=current"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "boot.shell_on_fail"
      "usb4=1"
    ];

    consoleLogLevel = 0;

    plymouth.enable = true;
  };

  # Networking
  networking.networkmanager.enable = true;
  networking.hostName = "lhs-desktop"; # Define your hostname.
  networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.
  networking.networkmanager.wifi.powersave = false;

  # Hardware
  hardware.graphics.enable = true;
  hardware.enableAllFirmware = true;
  hardware.opengl.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Locale
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };
}
