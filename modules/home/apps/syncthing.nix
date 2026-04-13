_:
{
  services.syncthing = {
    enable = true;
    settings = {
      gui.user = "ansonlee";
      devices = {
        "syncthing-k3s" = { id = "54BBHO4-O7R2VDC-P7AETXN-5KS3G2Q-NURAS7S-EIU5GJL-ZTLCA67-RMESMAU"; };
      };
    };
  };
}
