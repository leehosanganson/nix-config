{ pkgs, ... }: {
  i18n.inputMethod.fcitx5.addons = with pkgs; [
    fcitx5-rime
    fcitx5-table-extra
  ];
}
