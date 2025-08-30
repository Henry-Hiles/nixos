{pkgs, ...}: {
  services.xserver.excludePackages = [pkgs.xterm];
  environment.systemPackages = with pkgs; [
    tuba
    gradia
    ptyxis
    gapless
    resources
    wl-clipboard
    google-cursor
    papirus-icon-theme
    # crossPkgs.cinny-desktop
  ];
}
