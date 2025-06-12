{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: {
  environment.etc."librewolf/policies/policies.json".source = config.environment.etc."firefox/policies/policies.json".source;

  systemd.tmpfiles.settings.librewolf = {
    "/home/quadradical/.librewolf"."d".user = "quadradical";
    "/home/quadradical/.librewolf/quadradical"."d".user = "quadradical";
    "/home/quadradical/.librewolf/profiles.ini"."L+".argument = toString ((pkgs.formats.ini {}).generate "profiles.ini" {
      General = {
        StartWithLastProfile = 1;
      };
      Profile0 = rec {
        Default = 1;
        IsRelative = 1;
        Name = "quadradical";
        Path = Name;
      };
    });
    "/home/quadradical/.librewolf/quadradical/chrome"."L+".argument =
      toString
      (pkgs.symlinkJoin {
        name = "firefox-gnome-theme";
        paths = [./. inputs.firefox-gnome-theme];
      });
  };

  programs.firefox = {
    enable = true;
    package = pkgs.librewolf;

    autoConfig = lib.concatStringsSep "\n" (lib.mapAttrsToList (pref: value: "lockPref(\"${pref}\", ${builtins.toJSON value});") {
      "webgl.disabled" = false;
      "media.peerconnection.enabled" = true;
      "privacy.resistFingerprinting" = false;
      "privacy.fingerprintingProtection" = true;
      "browser.discovery.containers.enabled" = false;
      "svg.context-properties.content.enabled" = true;
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      "privacy.fingerprintingProtection.overrides" = "+AllTargets,-CSSPrefersColorScheme";
      "browser.uiCustomization.state" = "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"urlbar-container\",\"downloads-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"save-to-pocket-button\",\"developer-button\"],\"dirtyAreaCache\":[\"nav-bar\",\"PersonalToolbar\",\"toolbar-menubar\",\"TabsToolbar\"],\"currentVersion\":19}";
    });

    policies = {
      ShowHomeButton = false;

      DisableAccounts = true;
      DisableFormHistory = true;
      DisableFirefoxScreenshots = true;
      DisableSetDesktopBackground = true;
      DisableMasterPasswordCreation = true;

      # We use the Bitwarden extension for these
      PasswordManagerEnabled = false;
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;

      SanitizeOnShutdown = {
        Cache = false;
        Cookies = false;
        Downloads = true;
        FormData = true;
        History = false;
        Sessions = false;
        SiteSettings = false;
        OfflineApps = true;
        Locked = true;
      };

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

      UserMessaging = {
        WhatsNew = false;
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        UrlbarInterventions = false;
        SkipOnboarding = true;
        MoreFromMozilla = false;
        FirefoxLabs = false;
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

      ExtensionSettings = lib.mkForce (lib.listToAttrs (map (id: {
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
          "{de621c74-2aa6-4c91-a2da-28d445b66bab}" # YouTube Livestreams Theater Mode
          "{cf3dba12-a848-4f68-8e2d-f9fadc0721de}" # Google Lighthouse
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" # Bitwarden
          "{4ce83447-8255-43c2-b8f7-e02eb8c2cc39}" # Draw on Page
          "{ac34afe8-3a2e-4201-b745-346c0cf6ec7d}" # Better Youtube Shorts
          "{2327d818-55d3-441d-aea2-8b44aa2cb9aa}" # Toggle Website Colors
          "{a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7}" # User-Agent Switcher and Manager
          "enhancerforyoutube@maximerf.addons.mozilla.org"
        ]));

      SearchEngines = {
        Default = "DuckDuckGo";
        PreventInstalls = true;
        Add = [
          {
            Name = "Nix Package Search";
            URLTemplate = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
            IconURL = "https://github.com/NixOS/nixos-artwork/raw/refs/heads/master/logo/nix-snowflake-white.svg";
            Alias = "np";
          }
          {
            Name = "NixOS Option Search";
            URLTemplate = "https://search.nixos.org/options?channel=unstable&query={searchTerms}";
            IconURL = "https://github.com/NixOS/nixos-artwork/raw/refs/heads/master/logo/nix-snowflake-white.svg";
            Alias = "no";
          }
          {
            Name = "NixOS Wiki";
            URLTemplate = "https://wiki.nixos.org/w/index.php?search={searchTerms}";
            IconURL = "https://github.com/NixOS/nixos-artwork/raw/refs/heads/master/logo/nix-snowflake-white.svg";
            Alias = "nw";
          }
        ];
      };
    };
  };
}
