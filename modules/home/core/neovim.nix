{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Neovim
    neovim
    lua-language-server
    stylua
    selene
    prettierd

    # k8s
    helm-ls
    yaml-language-server
    kube-linter
    prettier

    # Nix
    nixd
    statix
    nixpkgs-fmt

    # plugins
    tree-sitter
    gdu
  ];
}
