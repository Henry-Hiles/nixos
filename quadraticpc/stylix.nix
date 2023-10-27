{pkgs, ...}: {
  stylix = {
    polarity = "dark";
    image = ./background.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
    targets.plymouth.blackBackground = false;

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
        package = pkgs.nerdfonts.override {fonts = ["FiraCode"];};
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
