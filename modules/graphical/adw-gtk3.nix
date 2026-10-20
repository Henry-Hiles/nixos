{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.adw-gtk3 ];
  users.users.quadradical.maid = {
    gsettings.settings.org.gnome.desktop.interface.gtk-theme = "adw-gtk3-dark";

    # adw-gtk3 only applies its dark colors when GTK prefers dark, and outside GNOME that comes from here
    file.xdg_config = builtins.listToAttrs (
      map (version: {
        name = "gtk-${version}/settings.ini";
        value.source = (pkgs.formats.ini { }).generate "settings.ini" {
          Settings.gtk-application-prefer-dark-theme = 1;
        };
      }) [ "3.0" "4.0" ]
    );
  };
}
