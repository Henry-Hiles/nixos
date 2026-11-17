{ pkgs, ... }:
{
  services.xserver.excludePackages = [ pkgs.xterm ];
  services.adw-bluetooth.enable = true;
  environment.systemPackages = with pkgs; [
    tuba
    gradia
    convey
    gapless
    showtime
    resources
    nmgui
    wl-clipboard
    google-cursor
    papirus-icon-theme
  ];
}
