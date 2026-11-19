{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
{
  environment.etc."librewolf/policies/policies.json".source =
    config.environment.etc."firefox/policies/policies.json".source;

  users.users.quadradical.maid.file.xdg_config = {
    "librewolf/librewolf/profiles.ini".source = (pkgs.formats.ini { }).generate "profiles.ini" {
      General = {
        StartWithLastProfile = 1;
      };
      Profile0 = rec {
        Default = 1;
        IsRelative = 1;
        Name = "quadradical";
        Path = Name;
      };
    };

    "librewolf/librewolf/quadradical/chrome".source = toString (
      pkgs.symlinkJoin {
        name = "firefox-gnome-theme";
        paths = [
          ./.
          inputs.firefox-gnome-theme
        ];
      }
    );
  };

  programs.firefox = {
    enable = true;
    package = pkgs.librewolf;

    autoConfig = lib.concatStringsSep "\n" (
      lib.mapAttrsToList (pref: value: "lockPref(\"${pref}\", ${builtins.toJSON value});") {
        "webgl.disabled" = false;
        "font.name-list.emoji" = "";
        "browser.tabs.groups.enabled" = false;
        "browser.fireButton.enabled" = false;
        "media.peerconnection.enabled" = true;
        "privacy.resistFingerprinting" = false;
        "browser.ml.linkPreview.enabled" = false;
        "privacy.fingerprintingProtection" = true;
        "browser.discovery.containers.enabled" = false;
        "svg.context-properties.content.enabled" = true;
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "privacy.fingerprintingProtection.overrides" = "+AllTargets,-CSSPrefersColorScheme,-JSDateTimeUTC";
        "browser.download.autohideButton" = true;
        "browser.uiCustomization.state" = builtins.toJSON {
          currentVersion = 28;
          placements = {
            nav-bar = [
              "back-button"
              "forward-button"
              "stop-reload-button"
              "urlbar-container"
              "downloads-button"
              "unified-extensions-button"
            ];
            TabsToolbar = [
              "tabbrowser-tabs"
              "new-tab-button"
              "alltabs-button"
            ];
          };
        };
      }
    );

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

      ExtensionSettings = lib.mkForce (
        lib.listToAttrs (
          map
            (id: {
              name = id;
              value = {
                install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${id}/latest.xpi";
                installation_mode = "force_installed";
                # In the extensions menu, not as separate toolbar buttons
                default_area = "menupanel";
              };
            })
            [
              "historyblock@kain"
              "uBlock0@raymondhill.net"
              "sponsorBlocker@ajay.app"
              "firefox@tampermonkey.net"
              "firefox-addon@pronoundb.org"
              "frankerfacez@frankerfacez.com"
              "{de621c74-2aa6-4c91-a2da-28d445b66bab}" # YouTube Livestreams Theater Mode
              "{446900e4-71c2-419f-a6a7-df9c091e268b}" # Bitwarden
              "enhancerforyoutube@maximerf.addons.mozilla.org"
            ]
        )
      );

      SearchEngines = {
        Default = "Federated Nexus Search";
        PreventInstalls = true;
        Add = [
          {
            Name = "Federated Nexus Search";
            URLTemplate = "https://search.federated.nexus/search?q={searchTerms}";
            IconURL = "https://federated.nexus/images/icon.svg";
          }
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
          {
            Name = "Nixpkgs PR Tracker";
            URLTemplate = "https://nixpkgs-tracker.ocfox.me/?pr={searchTerms}";
            IconURL = "https://github.com/NixOS/nixos-artwork/raw/refs/heads/master/logo/nix-snowflake-white.svg";
            Alias = "nt";
          }
          {
            Name = "Noogle";
            URLTemplate = "https://noogle.dev/q?term={searchTerms}";
            IconURL = "https://github.com/NixOS/nixos-artwork/raw/refs/heads/master/logo/nix-snowflake-white.svg";
            Alias = "ng";
          }
          {
            Name = "NüschtOS Search";
            URLTemplate = "https://search.xn--nschtos-n2a.de/?query={searchTerms}";
            IconURL = "https://github.com/NixOS/nixos-artwork/raw/refs/heads/master/logo/nix-snowflake-white.svg";
            Alias = "nu";
          }
          {
            Name = "Harmony";
            URLTemplate = "https://harmony.pulsewidth.org.uk/release?url={searchTerms}";
            IconURL = "https://harmony.pulsewidth.org.uk/favicon.ico";
            Alias = "hm";
          }
          {
            Name = "Pub";
            URLTemplate = "https://pub.dev/packages?q={searchTerms}";
            IconURL = "https://pub.dev/favicon.ico";
            Alias = "pub";
          }
        ];
        Remove = [
          "Bing"
          "LibRedirect"
          "Wikipedia (en)"
        ];
      };
    };
  };
}
