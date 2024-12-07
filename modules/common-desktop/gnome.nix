{pkgs, ...}: {
  environment.systemPackages = with pkgs.gnomeExtensions; [
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
  ];
}
