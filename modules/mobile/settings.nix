{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gnome-control-center
    (makeDesktopItem {
      name = "settings";
      desktopName = "Settings";
      exec = "env XDG_CURRENT_DESKTOP=GNOME gnome-control-center";
      icon = "org.gnome.Settings";
      startupWMClass = "org.gnome.Settings";
      categories = [ "Settings" ];
    })
  ];
}
