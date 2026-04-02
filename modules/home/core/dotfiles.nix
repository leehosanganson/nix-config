{ config, ... }:
let
  dotfilesPath = config.var.dotfilesDirectory;
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  configs = {
    ".config/ghostty" = "ghostty/.config/ghostty";
    ".config/nvim" = "nvim/.config/nvim";
    ".config/zsh/config" = "zsh/.config/zsh/config";
    ".config/tmux" = "tmux/.config/tmux";
    ".config/ai" = "ai/.config/ai";
    ".config/opencode" = "opencode/.config/opencode";
    ".ticker.yaml" = ".ticker.yaml";
    ".config/start-up" = "start-up/.config/start-up";
    ".config/wofi" = "wofi/.config/wofi";
    ".config/waybar" = "waybar/.config/waybar";
    ".config/swaync" = "swaync/.config/swaync";
  };
in
{
  home.file = builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${dotfilesPath}/${subpath}";
      recursive = true;
    })
    configs;
}
