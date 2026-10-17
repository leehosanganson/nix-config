{ pkgs, inputs, secretsPath, config, ... }: {
  imports = [ inputs.sops-nix.homeModules.sops ];

  home.packages = with pkgs; [
    sops
    age
  ];

  sops = {
    defaultSopsFile = "${secretsPath}/secrets.yaml";
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    secrets = {
      "litellm-pi-api-key" = { };
      "litellm-code-completion-api-key" = { };
      "fileshare-key" = { };
      "pve-terraform-api-token" = { };
    };
  };
}
