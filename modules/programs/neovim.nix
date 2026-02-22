{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Neovim
    neovim
    lua-language-server
    stylua
    selene

    # k8s
    helm-ls
    kube-linter
    prettier
    
    # Nix
    nixd
    statix
    nixpkgs-fmt
  ];
}
