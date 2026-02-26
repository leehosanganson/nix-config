_: {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.yazi.settings = {
    image_filter = "lanczos";
    image_quality = "90";
    show_hidden = true;
    show_symlink = true;
    sort_dir_first = true;
  };
}
