{pkgs, ...}: {
  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "ptyxis";
  };

  environment = {
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
      pkgs.ddcutil
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
