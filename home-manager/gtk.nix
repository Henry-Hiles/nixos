{pkgs, ...}: {
  gtk = {
    enable = true;

    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };

    # cursorTheme = {
    # name = "GoogleDot-Blue";
    # package = pkgs.nordzy-cursor-theme;
    # };
  };
}
