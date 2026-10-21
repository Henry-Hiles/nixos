{ pkgs, lib, ... }:
{
  programs.fht-compositor = {
    sessionPrograms.swayosd = "${lib.getExe' pkgs.swayosd "swayosd-server"} --style ${pkgs.writeText "swayosd.css" ''
      @import url("file://${pkgs.swayosd}/etc/xdg/swayosd/style.css");

      window#osd {
        background: shade(@theme_bg_color, 1.15);
      }
    ''}";

    settings.keybinds =
      lib.mapAttrs
        (_: args: {
          action = "run-command";
          arg = "${lib.getExe' pkgs.swayosd "swayosd-client"} ${args}";
          repeat = true;
        })
        {
          XF86AudioRaiseVolume = "--output-volume raise";
          XF86AudioLowerVolume = "--output-volume lower";
          XF86AudioMute = "--output-volume mute-toggle";
          XF86AudioMicMute = "--input-volume mute-toggle";
        };
  };
}
