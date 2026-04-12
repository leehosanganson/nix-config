{ ... }:
{
  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";
  nix.enable = false;

  imports = [
    ../../modules/common.nix
  ];

  # User
  users.users.ansonlee = {
    description = "Anson Lee";
    home = "/Users/ansonlee";
  };


  # ssh
  services.openssh.enable = true;
}
