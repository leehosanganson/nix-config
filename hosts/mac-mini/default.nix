{ ... }:
{
  system.primaryUser = "ansonlee";

  imports = [
    ../../modules/common.nix
    ../../modules/darwin/common.nix
    ../../modules/ssh/authorized-keys.nix
  ];
}
