{ pkgs, ... }: {
  home.packages = with pkgs; [
    kubectl
    k9s
    kubernetes-helm
    kubernetes-helm-completions
    velero
    fluxcd
  ];
}
