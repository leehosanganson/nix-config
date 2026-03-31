{ pkgs, inputs, dotfilesPath, ... }: {
  imports = [ inputs.sops-nix.homeModules.sops ];

  home.packages = with pkgs; [
    sops
    age
  ];

  sops = {
    defaultSopsFile = "${dotfilesPath}/secrets/secrets.yaml";
    age.keyFile = "/home/ansonlee/.config/sops/age/keys.txt";
    secrets = {
      "litellm-api-key" = { };
      "opencode-github-pat" = { };
    };
  };
}
