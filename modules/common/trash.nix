{ pkgs, ... }:
{
  environment.shellAliases.rm = "${pkgs.glib}/bin/gio trash";
}
