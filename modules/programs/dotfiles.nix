{ config, ... }:
let
  dotlink = path: config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/.dotfiles/${path}";
in
{
  home.file = {
    ".config/ghostty".source = dotlink "ghostty/.config/ghostty";
    ".config/nvim".source = dotlink "nvim/.config/nvim";
    ".config/zsh/config".source = dotlink "zsh/.config/zsh/config";
    "tmux.conf".source = dotlink "tmux/.config/tmux/tmux.conf";
    ".config/ai".source = dotlink "ai/.config/ai";
    ".config/opencode".source = dotlink "ai/.config/opencode";
    ".ticker.yaml".source = dotlink "ticker/.ticker.yaml";
  };
}
