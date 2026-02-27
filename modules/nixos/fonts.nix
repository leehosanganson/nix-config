{ pkgs, ... }: {
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack
    nerd-fonts.fira-code
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  fonts.enableDefaultPackages = true;
  fonts.fontconfig.enable = true;
}
