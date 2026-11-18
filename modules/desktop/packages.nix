{ pkgs, ... }:
{
  services.adw-bluetooth.enable = true;
  environment.systemPackages = with pkgs; [
    nmgui
    heroic
    inkscape
    libreoffice
    authenticator
    prismlauncher
  ];
}
