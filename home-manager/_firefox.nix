{inputs, ...}: {
  home.file.".mozilla/firefox/quadradical/chrome/firefox-gnome-theme".source = inputs.firefox-gnome-theme;

  programs.firefox = {
    enable = true;
    profiles.quadradical = {
      userChrome = ''
        @import "firefox-gnome-theme/userChrome.css";
      '';
      userContent = ''
        @import "firefox-gnome-theme/userContent.css";
      '';

      search.engines = {
        "Rabbit Search" = {
          urls = [{template = "https://rabbitsearch.org/search?q={searchTerms}";}];
          iconUpdateURL = "https://rabbit-company.com/images/logo.png";
          updateInterval = 7 * 24 * 60 * 60 * 1000; # One week
        };
      };
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.uidensity" = 0;
        "svg.context-properties.content.enabled" = true;
        "browser.theme.dark-private-windows" = false;
      };
    };
  };
}
