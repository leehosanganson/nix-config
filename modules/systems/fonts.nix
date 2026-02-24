{ pkgs, ... }: {
  fonts.packages = with pkgs; [
    (nerd-fonts.override {
      fonts = [
        "jetbrains-mono"
        "fira-mono"
        "fira-code"
        "hack"
      ];
    })

  ];

  fonts.enableDefaultFonts = false;
}
