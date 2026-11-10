{ pkgs, ... }:
{
  services.xserver.excludePackages = [ pkgs.xterm ];
  environment.systemPackages = with pkgs; [
    tuba
    gradia
    convey
    gapless
    showtime
    resources
    wl-clipboard
    google-cursor
    papirus-icon-theme
  ];
}
