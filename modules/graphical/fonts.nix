{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [inter nerd-fonts.fira-code twitter-color-emoji];
    enableDefaultPackages = false;
    fontconfig.defaultFonts = rec {
      serif = ["Inter"];
      sansSerif = serif;
      monospace = ["FiraCode Nerd Font"];
      emoji = ["Twitter Color Emoji"];
    };
  };
}
