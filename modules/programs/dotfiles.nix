{ config, inputs, ... }:
let
  inherit (inputs) dotfiles;
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";

  configs = {
    ".config/ghostty" = "ghostty/.config/ghostty";
    ".config/nvim" = "nvim/.config/nvim";
    ".config/zsh/config" = "zsh/.config/zsh/config";
    ".config/tmux/tmux.conf" = "tmux/.config/tmux/tmux.conf";
    ".config/ai" = "ai/.config/ai";
    ".config/opencode" = "ai/.config/opencode";
    ".ticker.yaml" = ".ticker.yaml";
    ".config/hypr" = "hyprland/.config/hypr";
    ".config/rofi" = "rofi/.config/rofi";
    ".config/waybar" = "waybar/.config/waybar";
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

