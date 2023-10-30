{pkgs, ...}: {
  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.swayfx;
    config = {
      modifier = "Mod4";
      # Use kitty as default terminal
      terminal = "kitty";
      startup = [
      ];
    };
  };
}
