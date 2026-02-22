{ pkgs, inputs, ... }: {
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  home.packages = with pkgs; [
    sops
    age
  ];

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.keyFile = "/home/ansonlee/.config/sops/age/keys.txt";
    secrets = {
      "my_password" = { };
    };
  };
}
