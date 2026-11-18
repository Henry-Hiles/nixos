{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  nixpkgs.overlays = [ inputs.quadshell.overlays.default ];

  # quadshell is GeoClue's agent, for its location toggle
  services.geoclue2 = {
    enableDemoAgent = false;
    whitelistedAgents = [ "quadshell" ];
  };

  environment.etc."niri/config.kdl".text = ''
    spawn-at-startup "${lib.getExe pkgs.quadshell}"
  '';
}
