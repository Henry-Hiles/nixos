# GNOME Shell mobile. GDM and the GNOME services/apps are in modules/graphical/gnome.
{ inputs, pkgs, ... }:
{
  nixpkgs.overlays = [ inputs.gnome-mobile.overlays.default ];

  services = {
    desktopManager.gnome = {
      enable = true;

      # One app per workspace
      extraGSettingsOverrides = ''
        [org.gnome.mutter]
        dynamic-workspaces=true
      '';
      extraGSettingsOverridePackages = [ pkgs.mutter ];
    };

    logind.settings.Login = {
      HandlePowerKey = "ignore";
      HandlePowerKeyLongPress = "poweroff";
    };
  };

  # GNOME talks to IBus over D-Bus, with these set the on-screen keyboard won't show up.
  environment.extraInit = ''
    unset GTK_IM_MODULE QT_IM_MODULE XMODIFIERS
  '';

  users.users.quadradical.maid.gsettings.settings.org.gnome = {
    desktop = {
      search-providers.sort-order = [
        "org.gnome.Contacts.desktop"
        "org.gnome.Documents.desktop"
        "org.gnome.Nautilus.desktop"
      ];

      background = rec {
        picture-uri = "file://${../../background.jpg}";
        picture-uri-dark = picture-uri;
      };

      lockdown.user-administration-disabled = true;
    };

    system.location.enabled = true;

    shell = {
      remember-mount-password = true;
      favorite-apps = [
        "librewolf.desktop"
        "org.gnome.Geary.desktop"
        "org.gnome.Nautilus.desktop"
      ];
    };
  };
}
