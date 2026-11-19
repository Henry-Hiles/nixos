{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.lib.stylix) colors;

  hyprlockConfig = pkgs.writeText "hyprlock.conf" ''
    auth {
      fingerprint {
        enabled = ${lib.boolToString config.services.fprintd.enable}
        ready_message = Scan fingerprint to unlock
        present_message = Scanning...
      }
    }

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
      ${lib.optionalString config.services.fprintd.enable "placeholder_text = $FPRINTPROMPT"}
    }
  '';
in
{
  options.quad.lock = lib.mkOption {
    type = lib.types.package;
    readOnly = true;
    description = "Locks the session with hyprlock, unless it's already running.";
    default = pkgs.writeShellScript "lock" ''
      exec ${lib.getExe' pkgs.util-linux "flock"} --nonblock "$XDG_RUNTIME_DIR/hyprlock.lock" \
        ${lib.getExe' config.systemd.package "systemd-cat"} --identifier=hyprlock \
        ${lib.getExe pkgs.hyprlock} --config ${hyprlockConfig}
    '';
  };

  config.security.pam.services.hyprlock.fprintAuth = false;
}
