{
  pkgs,
  inputs,
  ...
}: {
  home.file.".mozilla/firefox/quadradical/chrome/firefox-gnome-theme".source = inputs.firefox-gnome-theme;
  home.file.".mozilla/firefox/quadradical/chrome/nord.css".source = ./firefox-nord.css;

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

      search = {
        force = true;
        default = "Rabbit Search";
        engines = {
          "Rabbit Search" = {
            urls = [{template = "https://rabbitsearch.org/search?q={searchTerms}";}];
            iconUpdateURL = "https://rabbit-company.com/images/logo.png";
            updateInterval = 7 * 24 * 60 * 60 * 1000; # One week
          };

          "Nix Package Search" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "channel";
                    value = "unstable";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@np"];
          };

          "NixOS Option Search" = {
            urls = [
              {
                template = "https://search.nixos.org/options";
                params = [
                  {
                    name = "channel";
                    value = "unstable";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@no"];
          };

          "NixOS Wiki" = {
            urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@nw"];
          };

          "Home Manager Option Search" = {
            urls = [{template = "https://mipmip.github.io/home-manager-option-search/?query={searchTerms}";}];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@hm"];
          };

          "Bing".metaData.hidden = true;
          "Google".metaData.hidden = true;
          "DuckDuckGo".metaData.hidden = true;
          "Amazon.ca".metaData.hidden = true;
          "eBay".metaData.hidden = true;
        };
      };
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;
        "browser.uidensity" = 0;
        "browser.uiCustomization.state" = "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"urlbar-container\",\"downloads-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"save-to-pocket-button\",\"developer-button\"],\"dirtyAreaCache\":[\"nav-bar\",\"PersonalToolbar\",\"toolbar-menubar\",\"TabsToolbar\"],\"currentVersion\":19}";
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
      };
    };
  };
}
