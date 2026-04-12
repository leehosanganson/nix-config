{ ... }:

{
  home.username = "ansonlee";
  home.homeDirectory = "/Users/ansonlee";

  # Do not change
  home.stateVersion = "23.11";

  programs.home-manager.enable = true;

  imports = [
    ./sops.nix
    ../../modules/home/apps/dev.nix
    ../../modules/home/core
  ];

  home.file.".ssh/authorized_keys".text = ''
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII3aC4Qyn+J/JCcij7OU2+t5HrfqQGfVxfyQgsiDDzYe
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICZCH1vjRkNiw4b8btoOqd9WdPrN3lRc1lCrF3fWzfb+ leehosanganson@gmail.com
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB0LDIi3yFdEGJwy3ZvyXqwEMHA8bfbif7ZXZzGyM/og
  '';
}
