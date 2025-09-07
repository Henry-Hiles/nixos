{
  services = {
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
  };

  users.users.quadradical.maid.gsettings.settings.org.gnome = {
    desktop = {
      wm.preferences.focus-mode = "mouse";
      search-providers.sort-order = ["org.gnome.Contacts.desktop" "org.gnome.Documents.desktop" "org.gnome.Nautilus.desktop"];

      background = rec {
        picture-uri = "file://${./background.jpg}";
        picture-uri-dark = picture-uri;
      };

      interface = rec {
        color-scheme = "prefer-dark";

        cursor-theme = "GoogleDot-Blue";
        cursor-size = 24;

        icon-theme = "Papirus";
        toolkit-accessibility = false;

        font-name = "sans 11";
        document-font-name = font-name;
        monospace-font-name = "monospace";

        show-battery-percentage = true;
      };

      lockdown = {
        disable-printing = true;
        disable-print-setup = true;
        user-administration-disabled = true;
      };

      peripherals.touchpad.disable-while-typing = false;
    };

    shell = {
      remember-mount-password = true;
      favorite-apps = ["librewolf.desktop" "org.gnome.Geary.desktop" "org.gnome.Nautilus.desktop"];
    };

    mutter.edge-tiling = false;
    system.location.enabled = true;
    settings-daemon.plugins.media-keys.calculator-static = [];
  };
}
