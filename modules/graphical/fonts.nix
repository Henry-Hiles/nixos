{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [inter nerd-fonts.fira-code];
    enableDefaultPackages = false;
    fontconfig.defaultFonts = rec {
      serif = ["Inter"];
      sansSerif = serif;
      monospace = ["FiraCode Nerd Font"];
    };
  };
}
