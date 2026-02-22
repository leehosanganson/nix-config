{ pkgs, inputs, ... }: {
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  home.packages = with pkgs; [
    sops
    age
  ];

  sops = {
    defaultSopsFile = "./secrets.yaml";
    age.keyFile = "/var/lib/sops-nix/key.txt";
  };
}
