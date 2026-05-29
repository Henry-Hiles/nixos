{ pkgs, inputs, ... }:
{
  imports = [
    inputs.stylix.nixosModules.stylix
    inputs.home-manager.nixosModules.home-manager
  ];
  stylix = {
    enable = true;
    polarity = "dark";
    enableReleaseChecks = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
    targets = {
      qt.enable = false;
      plymouth = {
        enable = true;
        logo = ./logo.png;
      };
      fontconfig.enable = false;
      font-packages.enable = false;
    };
  };
}
