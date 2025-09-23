{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.adw-gtk3 ];
  users.users.quadradical.maid.gsettings.settings.org.gnome.desktop.interface.gtk-theme = "adw-gtk3";
}
