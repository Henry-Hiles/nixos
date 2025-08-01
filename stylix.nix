{pkgs, ...}: {
  stylix = {
    enable = true;
    polarity = "dark";
    image = ./background.jpg;
    enableReleaseChecks = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
    targets = {
      fontconfig.enable = false;
      font-packages.enable = false;
    };
  };
}
