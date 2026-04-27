{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.archipelago
    pkgs.mumble
  ];
}
