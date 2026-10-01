{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    heroic
    inkscape
    libreoffice
    authenticator
    prismlauncher
  ];
}
