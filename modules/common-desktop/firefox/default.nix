{
  lib,
  pkgs,
  inputs,
  ...
}: {
  # From https://hedgedoc.grimmauld.de/s/rVnTq0-Rs
  nixpkgs.overlays = lib.singleton (final: prev: {
    firefox = prev.firefox.overrideAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or []) ++ (with prev; [zip unzip gnused]);
      buildCommand =
        ''
          export buildRoot="$(pwd)"
        ''
        + old.buildCommand
        + ''
          pushd $buildRoot
          unzip $out/lib/firefox/browser/omni.ja -d patched_omni || ret=$?
          if [[ $ret && $ret -ne 2 ]]; then
            echo "unzip exited with unexpected error"
            exit $ret
          fi
          rm $out/lib/firefox/browser/omni.ja
          cd patched_omni
          sed -i 's/"enterprise_only"\s*:\s*true,//' modules/policies/schema.sys.mjs
          zip -0DXqr $out/lib/firefox/browser/omni.ja * # potentially qr9XD
          popd
        '';
    });
  });

  systemd.tmpfiles.settings.firefox."/home/quadradical/.mozilla/firefox/quadradical/chrome"."L+".argument =
    toString
    (pkgs.symlinkJoin {
      name = "firefox-gnome-theme";
      paths = [./. inputs.firefox-gnome-theme];
    });

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

      SearchEngines = {
        Default = "DuckDuckGo";
        Remove = ["Bing" "Google" "Amazon.ca" "eBay"];
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
            URLTemplate = "https://nixos.wiki/index.php?search={searchTerms}";
            IconURL = "https://github.com/NixOS/nixos-artwork/raw/refs/heads/master/logo/nix-snowflake-white.svg";
            Alias = "nw";
          }
          {
            Name = "Home Manager Option Search";
            URLTemplate = "https://mipmip.github.io/home-manager-option-search?query={searchTerms}";
            IconURL = "https://github.com/NixOS/nixos-artwork/raw/refs/heads/master/logo/nix-snowflake-white.svg";
            Alias = "hm";
          }
        ];
      };

      Preferences = {
        "gnomeTheme.oledBlack" = true; # Enable nord theme
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.uiCustomization.state" = "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"urlbar-container\",\"downloads-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"save-to-pocket-button\",\"developer-button\"],\"dirtyAreaCache\":[\"nav-bar\",\"PersonalToolbar\",\"toolbar-menubar\",\"TabsToolbar\"],\"currentVersion\":19}";
      };
    };
  };
}
