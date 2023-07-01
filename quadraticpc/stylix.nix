{pkgs, ...}: {
  stylix = {
    image = ./background.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";

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
