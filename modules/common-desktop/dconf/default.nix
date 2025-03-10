{
  lib,
  pkgs,
  ...
}: {
  programs.dconf.profiles.user.databases = [
    {
      # Can't lock because of home manager
      # lockAll = true;
      settings = lib.mapAttrs (_:
        lib.mapAttrs (name: value:
          if builtins.isInt value
          then lib.gvariant.mkInt32 value
          else value)) (with lib.gvariant; {
        "org/gnome/shell/extensions/rounded-window-corners-reborn" = {
          border-width = -5;
          skip-libadwaita-app = false;
          skip-libhandy-app = false;
        };
        "org/gnome/shell/extensions/pop-shell" = rec {
          active-hint = true;
          tile-by-default = true;
          active-hint-border-radius = mkUint32 16;
          gap-inner = mkUint32 3;
          gap-outer = gap-inner;
        };

        "org/gnome/shell/extensions/openbar" = {
          accent-color = ["0" "0.75" "0.75"];
          apply-accent-shell = false;
          apply-all-shell = false;
          apply-menu-notif = false;
          apply-menu-shell = false;
          auto-bgalpha = true;
          autofg-bar = false;
          autofg-menu = false;
          autohg-bar = false;
          autohg-menu = true;
          autotheme-dark = "Pastel";
          autotheme-font = false;
          autotheme-light = "Pastel";
          balpha = 1.0;
          bartype = "Islands";
          bcolor = ["0.522" "0.682" "0.808"];
          bg-change = true;
          bgalpha = 0.0;
          bgcolor = ["0.275" "0.325" "0.408"];
          bgcolor-wmax = ["0.118" "0.118" "0.118"];
          bgcolor2 = ["0.235" "0.353" "0.518"];
          bgpalette = true;
          boxalpha = 0.0;
          boxcolor = ["0.275" "0.325" "0.408"];
          bradius = 24.0;
          bwidth = 1.0;
          candyalpha = 1.0;
          candybar = false;
          color-scheme = "prefer-dark";
          count1 = 308842;
          count10 = 61;
          count11 = 5;
          count12 = 1;
          count2 = 275315;
          count3 = 26465;
          count4 = 7327;
          count5 = 6382;
          count6 = 246;
          count7 = 153;
          count8 = 115;
          count9 = 88;
          dark-bcolor = ["0.522" "0.682" "0.808"];
          dark-bgcolor = ["0.275" "0.325" "0.408"];
          dark-bgcolor-wmax = ["0.118" "0.118" "0.118"];
          dark-bgcolor2 = ["0.235" "0.353" "0.518"];
          dark-boxcolor = ["0.275" "0.325" "0.408"];
          dark-fgcolor = ["0.600" "0.757" "0.945"];
          dark-hcolor = ["0.333" "0.420" "0.537"];
          dark-hscd-color = ["0.302" "0.510" "0.765"];
          dark-iscolor = ["0.275" "0.325" "0.408"];
          dark-mbcolor = ["0.769" "0.780" "0.812"];
          dark-mbgcolor = ["0.27450981736183167" "0.32549020648002625" "0.40784314274787903"];
          dark-mfgcolor = ["1" "1" "1"];
          dark-mscolor = ["0.302" "0.510" "0.765"];
          dark-mshcolor = ["0.000" "0.000" "0.000"];
          dark-palette1 = ["97" "129" "169"];
          dark-palette10 = ["72" "92" "132"];
          dark-palette11 = ["60" "90" "132"];
          dark-palette12 = ["84" "84" "92"];
          dark-palette2 = ["45" "53" "62"];
          dark-palette3 = ["70" "83" "104"];
          dark-palette4 = ["85" "107" "137"];
          dark-palette5 = ["115" "157" "190"];
          dark-palette6 = ["133" "174" "206"];
          dark-palette7 = ["196" "199" "207"];
          dark-palette8 = ["126" "163" "204"];
          dark-palette9 = ["139" "153" "175"];
          dark-shcolor = ["0.000" "0.000" "0.000"];
          dark-smbgcolor = ["0.827" "0.855" "0.890"];
          dark-vw-color = ["0.302" "0.510" "0.765"];
          dark-winbcolor = ["0.302" "0.510" "0.765"];
          default-font = "Sans 12";
          fgalpha = 1.0;
          fgcolor = ["0.600" "0.757" "0.945"];
          fitts-widgets = true;
          font = "Cantarell 12";
          gradient = false;
          halpha = 1.0;
          hcolor = ["0.333" "0.420" "0.537"];
          height = 40.0;
          hscd-color = ["0.302" "0.510" "0.765"];
          import-export = false;
          isalpha = 1.0;
          iscolor = ["0.275" "0.325" "0.408"];
          margin = 5.0;
          mbalpha = 0.0;
          mbcolor = ["0.7z69" "0.780" "0.812"];
          mbgalpha = 1.0;
          mbgcolor = ["0.27450981736183167" "0.32549020648002625" "0.40784314274787903"];
          menustyle = true;
          mfgalpha = 1.0;
          mfgcolor = ["1" "1" "1"];
          mhcolor = ["0" "0.7" "0.9"];
          monitor-height = 1440;
          monitor-width = 2560;
          mscolor = ["0.302" "0.510" "0.765"];
          mshcolor = ["0.000" "0.000" "0.000"];
          neon = false;
          palette1 = ["97" "129" "169"];
          palette10 = ["72" "92" "132"];
          palette11 = ["60" "90" "132"];
          palette12 = ["84" "84" "92"];
          palette2 = ["45" "53" "62"];
          palette3 = ["70" "83" "104"];
          palette4 = ["85" "107" "137"];
          palette5 = ["115" "157" "190"];
          palette6 = ["133" "174" "206"];
          palette7 = ["196" "199" "207"];
          palette8 = ["126" "163" "204"];
          palette9 = ["139" "153" "175"];
          pause-reload = false;
          position = "Top";
          radius-bottomleft = true;
          radius-topleft = true;
          radius-topright = true;
          reloadstyle = false;
          set-overview = false;
          shadow = false;
          smbgcolor = ["0.827" "0.855" "0.890"];
          smbgoverride = false;
          trigger-autotheme = false;
          trigger-reload = false;
          vw-color = ["0.302" "0.510" "0.765"];
          winbcolor = ["0.302" "0.510" "0.765"];
        };

        "org/gnome/shell/extensions/just-perfection" = {
          accessibility-menu = false;
          activities-button = true;
          calendar = true;
          clock-menu = true;
          clock-menu-position = 0;
          dash = false;
          dash-app-running = false;
          dash-separator = false;
          events-button = false;
          keyboard-layout = false;
          panel-size = 0;
          power-icon = true;
          quick-settings = true;
          quick-settings-dark-mode = false;
          show-apps-button = false;
          startup-status = 0;
          window-menu-take-screenshot-button = false;
          window-picker-icon = true;
          workspace = true;
          workspace-switcher-size = 0;
          world-clock = false;
        };

        "org/gnome/shell/extensions/display-brightness-ddcutil" = {
          allow-zero-brightness = true;
          button-location = 1;
          ddcutil-binary-path = lib.meta.getExe pkgs.ddcutil;
          ddcutil-queue-ms = 130.0;
          ddcutil-sleep-multiplier = 40.0;
          decrease-brightness-shortcut = ["XF86MonBrightnessDown"];
          increase-brightness-shortcut = ["XF86MonBrightnessUp"];
          hide-system-indicator = true;
          only-all-slider = true;
          position-system-menu = 3.0;
          show-internal-slider = false;
          show-all-slider = true;
          show-display-name = false;
          show-osd = true;
          show-value-label = false;
          step-change-keyboard = 2.0;
        };

        "org/gnome/shell/extensions/burn-my-windows".active-profile = toString ./burn-my-windows.conf;

        "org/gnome/desktop/wm/preferences".focus-mode = "mouse";

        "org/gnome/shell" = {
          disable-user-extensions = true;
          enabled-extensions = [
            "openbar@neuromorph"
            "blur-my-shell@aunetx"
            "caffeine@patapon.info"
            "pop-shell@system76.com"
            "rounded-window-corners@fxgn"
            "burn-my-windows@schneegans.github.com"
            "fullscreen-avoider@noobsai.github.com"
            "appindicatorsupport@rgcjonas.gmail.com"
            "compiz-windows-effect@hermes83.github.com"
            "user-theme@gnome-shell-extensions.gcampax.github.com"
            "display-brightness-ddcutil@themightydeity.github.com"
            "system-monitor@gnome-shell-extensions.gcampax.github.com"
            "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
          ];
          disabled-extensions = [
            "just-perfection-desktop@just-perfection"
          ];
        };

        "org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = ["/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"];

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
          binding = "<Super>e";
          command = "nautilus";
          name = "Files";
        };

        "org/gnome/desktop/search-providers".sort-order = ["org.gnome.Contacts.desktop" "org.gnome.Documents.desktop" "org.gnome.Nautilus.desktop"];

        "org/gnome/desktop/interface" = rec {
          color-scheme = "prefer-dark";
          enable-animations = true;

          cursor-theme = "GoogleDot-Blue";
          cursor-size = 24;

          gtk-theme = "adw-gtk3";
          icon-theme = "Papirus";
          toolkit-accessibility = false;

          font-hinting = "slight";
          font-antialiasing = "grayscale";

          font-name = "Cantarell 11";
          document-font-name = font-name;
          monospace-font-name = "FiraCode Nerd Font 11";
        };

        #         "org/gnome/Ptyxis".default-profile-uuid = "quadradical";
        #
        #         "org/gnome/Ptyxis/Profiles/quadradical".palette = "nord";
      });
    }
  ];
}
