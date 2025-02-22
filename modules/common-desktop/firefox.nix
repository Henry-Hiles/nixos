{lib, ...}: {
  programs.firefox = {
    enable = true;

    policies = {
      ShowHomeButton = false;

      DisablePocket = true;
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisableFirefoxScreenshots = true;
      DisableSetDesktopBackground = true;
      DisableMasterPasswordCreation = true;

      DontCheckDefaultBrowser = true;

      HttpsOnlyMode = "force_enabled";

      DisplayMenuBar = "never";
      DisplayBookmarksToolbar = "never";

      DNSOverHTTPS.Enabled = false;

      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };

      FirefoxHome = {
        TopSites = true;
        SponsoredTopSites = false;

        Pocket = false;
        Snippets = false;
        Highlights = false;
        Locked = true;
      };

      FirefoxSuggest = {
        WebSuggestions = false;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
        Locked = true;
      };

      ExtensionSettings = lib.mkForce (lib.listToAttrs (lib.map (id: {
          name = id;
          value = {
            install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${id}/latest.xpi";
            installation_mode = "force_installed";
          };
        }) [
          "historyblock@kain"
          "uBlock0@raymondhill.net"
          "sponsorBlocker@ajay.app"
          "jid1-MnnxcxisBPnSXQ@jetpack" # Privacy Badger
          "frankerfacez@frankerfacez.com"
          "7esoorv3@alefvanoon.anonaddy.me" # LibRedirect
          "{4ce83447-8255-43c2-b8f7-e02eb8c2cc39}" # Draw on Page
          "{ac34afe8-3a2e-4201-b745-346c0cf6ec7d}" # Better Youtube Shorts
          "{2327d818-55d3-441d-aea2-8b44aa2cb9aa}" # Toggle Website Colors
          "{a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7}" # User-Agent Switcher and Manager
          "enhancerforyoutube@maximerf.addons.mozilla.org"
        ]));

      # Have to disable search engines for now because mozilla stupidly only supports it on ESR...

      # SearchEngines = {
      #   Default = "DuckDuckGo";
      #   Remove = ["Bing" "Google" "Amazon.ca" "eBay"];
      #   Add = [
      #     {
      #       Name = "Nix Package Search";
      #       URLTemplate = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
      #       IconURL = "https://github.com/NixOS/nixos-artwork/raw/refs/heads/master/logo/nix-snowflake-white.svg";
      #       Alias = "np";
      #     }
      #     {
      #       Name = "NixOS Option Search";
      #       URLTemplate = "https://search.nixos.org/options?channel=unstable&query={searchTerms}";
      #       IconURL = "https://github.com/NixOS/nixos-artwork/raw/refs/heads/master/logo/nix-snowflake-white.svg";
      #       Alias = "no";
      #     }
      #     {
      #       Name = "NixOS Wiki";
      #       URLTemplate = "https://nixos.wiki/index.php?search={searchTerms}";
      #       IconURL = "https://github.com/NixOS/nixos-artwork/raw/refs/heads/master/logo/nix-snowflake-white.svg";
      #       Alias = "nw";
      #     }
      #     {
      #       Name = "Home Manager Option Search";
      #       URLTemplate = "https://mipmip.github.io/home-manager-option-search?query={searchTerms}";
      #       IconURL = "https://github.com/NixOS/nixos-artwork/raw/refs/heads/master/logo/nix-snowflake-white.svg";
      #       Alias = "hm";
      #     }
      #   ];
      # };

      Preferences = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
    };
  };
}
