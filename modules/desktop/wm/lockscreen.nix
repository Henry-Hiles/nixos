{
  config,
  pkgs,
  lib,
  ...
}:
let
  lock = "pidof gtklock || ${lib.getExe config.programs.gtklock.package}";
in
{
  services.logind.settings.Login.HandlePowerKey = "suspend";

  programs.fht-compositor = {
    # We log in automatically, so lock straight away.
    settings.autostart = [ lock ];

    sessionPrograms.hypridle = "${lib.getExe pkgs.hypridle} --config ${pkgs.writeText "hypridle.conf" ''
      general {
        lock_cmd = ${lock}
        before_sleep_cmd = loginctl lock-session
      }
    ''}";
  };
}
