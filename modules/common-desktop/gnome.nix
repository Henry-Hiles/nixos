{pkgs, ...}: {
  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "ptyxis";
  };

  environment = {
    sessionVariables.XDG_CURRENT_DESKTOP = "GNOME";

    systemPackages = with pkgs.gnomeExtensions; [
      caffeine
      open-bar
      pop-shell
      appindicator
      blur-my-shell
      just-perfection
      burn-my-windows
      fullscreen-avoider
      compiz-windows-effect
      rounded-window-corners-reborn
      brightness-control-using-ddcutil
    ];

    gnome.excludePackages = with pkgs; [
      yelp
      totem
      xterm
      evince
      snapshot
      epiphany
      gnome-logs
      gnome-tour
      gnome-music
      gnome-console
      gnome-calendar
      gnome-software
      gnome-characters
      gnome-text-editor
      gnome-system-monitor
    ];
  };
}
