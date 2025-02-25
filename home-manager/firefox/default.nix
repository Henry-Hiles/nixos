{inputs, ...}: {
  home.file.".mozilla/firefox/quadradical/chrome/firefox-gnome-theme".source = inputs.firefox-gnome-theme;
  home.file.".mozilla/firefox/quadradical/chrome/nord.css".source = ./nord.css;

  programs.firefox = {
    enable = true;

    profiles.quadradical = {
      isDefault = true;
      userChrome = ''
        @import "firefox-gnome-theme/userChrome.css";
        @import "nord.css"
      '';
      userContent = ''
        @import "firefox-gnome-theme/userContent.css";
      '';
    };
  };
}
