{ pkgs, inputs, config, ... }: {
  imports = [ inputs.sops-nix.homeModules.sops ];

  home.packages = with pkgs; [
    sops
    age
  ];

  sops = {
    defaultSopsFile = "${inputs.dotfiles}/secrets/secrets.yaml";
    age.keyFile = "/home/ansonlee/.config/sops/age/keys.txt";
    secrets = {
      "opencode_auth" = {
        path = "${config.home.homeDirectory}/.local/share/opencode/auth.json";
      };
    };
  };

  # Dummy file for secrets path
  home.file."local/share/opencode/.keep".text = "";
}
