{
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.swayfx;
    config = rec {
      modifier = "Mod4";
      terminal = "kgx";
      window = {
        titlebar = false;
      };
      bars = [];

      keybindings = lib.mkOptionDefault {
        "${modifier}+button4" = "workspace prev";
        "${modifier}+button5" = "workspace next";
        "${modifier}+t" = "exec ${terminal}";
        "${modifier}+q" = "kill";
        "XF86AudioRaiseVolume" = "swayosd --output-volume raise";
        "XF86AudioLowerVolume" = "swayosd --output-volume lower";
        "XF86MonBrightnessUp" = "swayosd --output-brightness raise";
        "XF86MonBrightnessDown" = "swayosd --brightness lower";
      };
    };
  };

  services.swayosd.enable = true;
}
