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
  };

  # DON'T TOUCH THIS
  options = {
    var = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
  };
}
