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
            "blur-my-shell@aunetx"
            "caffeine@patapon.info"
            "pop-shell@system76.com"
            "rounded-window-corners@fxgn"
            "burn-my-windows@schneegans.github.com"
            "fullscreen-avoider@noobsai.github.com"
            "appindicatorsupport@rgcjonas.gmail.com"
            "compiz-windows-effect@hermes83.github.com"
            "display-brightness-ddcutil@themightydeity.github.com"
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

          font-name = "sans";
          document-font-name = font-name;
          monospace-font-name = "monospace";
        };

        #         "org/gnome/Ptyxis".default-profile-uuid = "quadradical";
        #
        #         "org/gnome/Ptyxis/Profiles/quadradical".palette = "nord";
      });
    }
  ];
}
