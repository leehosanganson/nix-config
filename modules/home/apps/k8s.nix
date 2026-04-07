{ pkgs, ... }: {
  home.packages = with pkgs; [
    kubectl
    k9s
    kubernetes-helm
    fluxcd
    kubectl-cnpg
  ];
}
