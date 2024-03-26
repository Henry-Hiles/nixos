{pkgs, ...}: {
  environment.systemPackages = with pkgs.gnomeExtensions; [
    caffeine
    pop-shell
    appindicator
    blur-my-shell
    just-perfection
    burn-my-windows
    fullscreen-avoider
    compiz-windows-effect
  ];
}
