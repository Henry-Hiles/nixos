{ pkgs, ... }:
{
  services.xserver.excludePackages = [ pkgs.xterm ];
  environment.systemPackages = with pkgs; [
    tuba
    geary
    gradia
    gapless
    showtime
    resources
    wl-clipboard
    google-cursor
    papirus-icon-theme
  ];
}
