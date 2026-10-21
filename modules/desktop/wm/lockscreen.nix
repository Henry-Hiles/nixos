{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.logind.settings.Login.HandlePowerKey = "suspend";

  programs = {
    hyprlock.enable = true;

    fht-compositor.sessionPrograms.hypridle =
      "${lib.getExe pkgs.hypridle} --config ${pkgs.writeText "hypridle.conf" ''
        general {
          lock_cmd = pidof hyprlock || ${lib.getExe pkgs.hyprlock} --config ${
            let
              inherit (config.lib.stylix) colors;
            in
            pkgs.writeText "hyprlock.conf" ''
              background {
                path = screenshot
                blur_passes = 3
              }

              label {
                text = $TIME
                font_size = 96
                position = 0, 200
              }

              label {
                text = cmd[update:60000] date +"%A, %B %-d"
                font_size = 20
                position = 0, 110
              }

              input-field {
                size = 300, 50
                outline_thickness = 0
                inner_color = rgb(${colors.base01})
                font_color = rgb(${colors.base05})
                check_color = rgb(${colors.base0D})
                fade_on_empty = false
              }
            ''
          }
          before_sleep_cmd = loginctl lock-session
        }
      ''}";
  };
}
