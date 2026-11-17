{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.logind.settings.Login.HandlePowerKey = "suspend";

  programs.fht-compositor = {
    # We log in automatically, so lock straight away.
    settings.autostart = [ "${config.quad.lock}" ];

    sessionPrograms.hypridle = "${lib.getExe pkgs.hypridle} --config ${pkgs.writeText "hypridle.conf" ''
      general {
        lock_cmd = ${config.quad.lock}
        before_sleep_cmd = loginctl lock-session
      }
    ''}";
  };
}
