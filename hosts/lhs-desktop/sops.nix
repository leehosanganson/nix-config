{ pkgs, inputs, ... }: {
  imports = [ inputs.sops-nix.homeModules.sops ];

  home.packages = with pkgs; [
    sops
    age
  ];

  sops = {
    defaultSopsFile = "${inputs.dotfiles}/secrets/secrets.yaml";
    age.keyFile = "/home/ansonlee/.config/sops/age/keys.txt";
    secrets = {
      "litellm-api-key" = { };
    };
  };
}
