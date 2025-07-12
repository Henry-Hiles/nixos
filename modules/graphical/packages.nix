{pkgs, ...}: {
  services.xserver.excludePackages = [pkgs.xterm];
  environment.systemPackages = with pkgs; [
    tuba
    ptyxis
    gapless
    resources
    wl-clipboard
    google-cursor
    authenticator
    papirus-icon-theme
  ];
}
