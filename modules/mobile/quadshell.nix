{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  nixpkgs.overlays = [ inputs.quadshell.overlays.default ];

  # The flashlight LED's brightness is writable by this group
  users.users.quadradical.extraGroups = [ "feedbackd" ];

  environment.etc."niri/config.kdl".text = ''
    spawn-at-startup "${lib.getExe pkgs.quadshell}"
  '';
}
