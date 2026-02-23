{ config, inputs, ... }:
let
  inherit (inputs) dotfiles;
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";

  configs = {
    ghostty = "ghostty/.config/ghostty";
    nvim = "nvim/.config/nvim";
    zsh = "zsh/.config/zsh/config";
    tmux = "tmux/.config/tmux/tmux.conf";
    ai = "ai/.config/ai";
    opencode = "ai/.config/opencode";
    ticker = ".ticker.yaml";
    hypr = "hyprland/.config/hypr";
    rofi = "rofi/.config/rofi";
    waybar = "waybar/.config/waybar";
  };
in
{
  home.file = builtins.mapAttrs
    (name: subpath: {
      source = create_symlink subpath;
      recursive = true;
    })
    configs;
}

