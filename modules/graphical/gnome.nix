{pkgs, ...}: {
  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "ptyxis";
  };

  environment = {
    sessionVariables.XDG_CURRENT_DESKTOP = "GNOME";

    systemPackages = with pkgs.gnomeExtensions; [
      valent
      pop-shell
      appindicator
      blur-my-shell
      just-perfection
      burn-my-windows
      fullscreen-avoider
      launch-new-instance
      compiz-windows-effect
      rounded-window-corners-reborn
      brightness-control-using-ddcutil
    ];

    gnome.excludePackages = with pkgs; [
      yelp
      totem
      xterm
      evince
      decibels
      snapshot
      epiphany
      gnome-logs
      gnome-tour
      gnome-music
      simple-scan
      gnome-console
      gnome-software
      gnome-user-docs
      gnome-characters
      gnome-font-viewer
      gnome-connections
      gnome-text-editor
      gnome-system-monitor
    ];
  };
}
