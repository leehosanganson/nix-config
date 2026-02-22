{ pkgs, inputs, config, ... }: {
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  home.packages = with pkgs; [
    sops
    age
  ];

  sops = {
    defaultSopsFile = "${inputs.dotfiles}/secrets/secrets.yaml";
    age.keyFile = "/home/ansonlee/.config/sops/age/keys.txt";
    secrets = {
      # "my_password" = {
      #   path = "${config.home.homeDirectory}/example.txt";
      # };
      # "another_password" = {
      #   path = "${config.home.homeDirectory}/example2.txt";
      # };
    };
  };
}
