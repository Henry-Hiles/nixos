{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [inter nerd-fonts.fira-code];
    fontconfig.defaultFonts = rec {
      serif = ["Inter"];
      sansSerif = serif;
      monospace = ["FiraCode Nerd Font"];
    };
  };
}
