{ ... }:
{
  system.primaryUser = "ansonlee";

  imports = [
    ../../modules/common.nix
    ../../modules/darwin/common.nix
  ];

  users.users.ansonlee.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICZCH1vjRkNiw4b8btoOqd9WdPrN3lRc1lCrF3fWzfb+ leehosanganson@gmail.com" # lhs-mbp
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFOuRvc3yYsvjGSLlvtiSTGYx8YscOGAxuLoQEgP/llb leehosanganson@gmail.com" # lhs-desktop
  ];
}
