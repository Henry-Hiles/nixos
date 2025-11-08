{
  pkgs,
  lib,
  ...
}:
{
  environment = {
    systemPackages = with pkgs.gnomeExtensions; [
      valent
      pop-shell
      appindicator
      blur-my-shell
      just-perfection
      burn-my-windows
      launch-new-instance
      compiz-windows-effect
      rounded-window-corners-reborn
      brightness-control-using-ddcutil
    ];

    gnome.excludePackages = with pkgs; [
      yelp
      orca
      totem
      xterm
      evince
      decibels
      epiphany
      gnome-logs
      gnome-tour
      gnome-music
      simple-scan
      gnome-console
      gnome-software
      gnome-user-docs
      gnome-characters
      gnome-font-viewer
      gnome-connections
      gnome-text-editor
      gnome-system-monitor
    ];
  };

  users.users.quadradical.maid.gsettings.settings.org.gnome.shell = {
    disable-user-extensions = false;
    allow-extension-installation = false;
    enabled-extensions = [
      "blur-my-shell@aunetx"
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

    extensions = {
      rounded-window-corners-reborn = {
        border-width = -5;
        skip-libadwaita-app = false;
        skip-libhandy-app = false;
      };

      pop-shell = rec {
        active-hint = true;
        tile-by-default = true;
        active-hint-border-radius = 16;
        gap-inner = 3;
        gap-outer = gap-inner;
      };

      just-perfection = {
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

      display-brightness-ddcutil = {
        allow-zero-brightness = true;
        button-location = 1;
        ddcutil-binary-path = lib.meta.getExe pkgs.ddcutil;
        decrease-brightness-shortcut = [ "XF86MonBrightnessDown" ];
        increase-brightness-shortcut = [ "XF86MonBrightnessUp" ];
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

      burn-my-windows.active-profile = toString ./burn-my-windows.conf;
    };
  };
}
