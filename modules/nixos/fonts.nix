{ pkgs, ... }: {
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack
    nerd-fonts.fira-code
  ];

  fonts.enableDefaultPackages = true;
  fonts.fontconfig.enable = true;
}
