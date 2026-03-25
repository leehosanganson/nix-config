{ config, ... }:
let
  dotfiles = "${config.home.homeDirectory}/nixos-config/dotfiles";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  configs = {
    ".config/ghostty" = "ghostty/.config/ghostty";
    ".config/nvim" = "nvim/.config/nvim";
    ".config/zsh/config" = "zsh/.config/zsh/config";
    ".config/tmux/tmux.conf" = "tmux/.config/tmux/tmux.conf";
    ".config/ai" = "ai/.config/ai";
    ".config/opencode/opencode.json" = "ai/.config/opencode/opencode.json";
    ".ticker.yaml" = ".ticker.yaml";
    ".config/start-up" = "start-up/.config/start-up";
    ".config/wofi" = "wofi/.config/wofi";
    ".config/waybar" = "waybar/.config/waybar";
  };
in
{
  home.file = builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;
}

