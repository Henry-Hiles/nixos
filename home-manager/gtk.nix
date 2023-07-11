{pkgs, ...}: {
  gtk = {
    enable = true;

    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };

    # cursorTheme = {
      # name = "Bibata-Modern-Classic";
      # package = pkgs.bibata-cursors;
    # };
  };
}
