{ ... }:
{
  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";
  nix.enable = false;

  imports = [
    ../../modules/common.nix
  ];

  # ssh
  services.openssh.enable = true;

  # User
  users.users.ansonlee = {
    description = "Anson Lee";
    home = "/Users/ansonlee";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII3aC4Qyn+J/JCcij7OU2+t5HrfqQGfVxfyQgsiDDzYe"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICZCH1vjRkNiw4b8btoOqd9WdPrN3lRc1lCrF3fWzfb+ leehosanganson@gmail.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB0LDIi3yFdEGJwy3ZvyXqwEMHA8bfbif7ZXZzGyM/og"
    ];
  };
}
