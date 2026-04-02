{ config
, lib
, ...
}: {
  imports = [
    # Choose your theme here:
    ../../modules/themes/zen.nix
  ];

  config.var = {
    username = "ansonlee";
    hostname = "lhs-desktop";
    configDirectory = "/home/" + config.var.username + "/nix-config";
    dotfilesDirectory = " /home/" + config.var.username + "dotfiles";
  };

  # DON'T TOUCH THIS
  options = {
    var = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
  };
}
