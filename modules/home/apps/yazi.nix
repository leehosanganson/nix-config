_: {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";
  };

  programs.yazi.settings = {
    mgr = {
      show_hidden = true;
      show_symlink = true;
      sort_dir_first = true;
    };
    preview = {
      image_filter = "lanczos";
      image_quality = "90";
    };
  };
}
