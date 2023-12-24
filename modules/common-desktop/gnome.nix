{pkgs, ...}: {
  environment.systemPackages = with pkgs.gnomeExtensions; [
    caffeine
    pop-shell
    appindicator
    search-light
    blur-my-shell
    just-perfection
    burn-my-windows
    fullscreen-avoider
    compiz-windows-effect
  ];
}
