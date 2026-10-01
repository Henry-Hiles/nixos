{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    fd
    glib
    killall
  ];
}
