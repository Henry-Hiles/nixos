{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [twitter-color-emoji];
    fontconfig.defaultFonts.emoji = ["Twitter Color Emoji"];
  };
}
