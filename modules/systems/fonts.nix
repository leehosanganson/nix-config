{ pkgs, ... }: {
  fonts.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "JeyBrainsMono"
        "FiraCode"
        "Hack"
      ];
    })

  ];

  fonts.enableDefaultFonts = false;
}
