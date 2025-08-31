{pkgs, ...}: {
  stylix = {
    enable = true;
    polarity = "dark";
    image = ./background.jpg;
    enableReleaseChecks = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
    targets = {
      plymouth = {
        enable = true;
        logo = ./logo.png;
      };
      fontconfig.enable = false;
      font-packages.enable = false;
    };
  };
}
