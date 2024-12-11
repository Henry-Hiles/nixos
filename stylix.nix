{pkgs, ...}: {
  stylix = {
    enable = true;
    polarity = "dark";
    image = ./background.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";

    cursor = {
      name = "GoogleDot-Blue";
      package = pkgs.google-cursor;
      size = 24;
    };

    fonts = {
      serif = {
        name = "Cantarell";
        package = pkgs.cantarell-fonts;
      };

      sansSerif = {
        name = "Cantarell";
        package = pkgs.cantarell-fonts;
      };

      monospace = {
        name = "FiraCode Nerd Font";
        package = pkgs.nerd-fonts.fira-code;
      };

      emoji = {
        name = "Twitter Color Emoji";
        package = pkgs.twitter-color-emoji;
      };

      sizes = {
        applications = 11;
        desktop = 11;
      };
    };
  };
}
