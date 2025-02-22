{
  inputs,
  pkgs,
  ...
}: {
  home.file.".mozilla/firefox/quadradical/chrome/firefox-gnome-theme".source = inputs.firefox-gnome-theme;
  home.file.".mozilla/firefox/quadradical/chrome/nord.css".source = ./firefox-nord.css;

  programs.firefox = {
    enable = true;
    profiles.quadradical = {
      isDefault = true;

      search = {
        force = true;
        default = "LibreY";
        engines = {
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

          "LibreY" = {
            urls = [{template = "https://search.winscloud.net/search.php?q={searchTerms}";}];
            iconUpdateURL = "https://search.winscloud.net/favicon.ico";
          };

          "Bing".metaData.hidden = true;
          "Google".metaData.hidden = true;
          "Amazon.ca".metaData.hidden = true;
          "eBay".metaData.hidden = true;
        };
      };

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
