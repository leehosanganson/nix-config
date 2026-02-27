{ pkgs, ... }: {
  i18n.inputMethod.fcitx5.addons = with pkgs; [
    kdePackages.fcitx5-chinese-addons
    fcitx5-lua
    fcitx5-rime
    rime-data
    fcitx5-table-extra
  ];
}
