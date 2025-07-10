{pkgs, ...}: {
  services.xserver.excludePackages = [pkgs.xterm];
  environment.systemPackages = with pkgs; [
    tuba
    gimp
    deno
    heroic
    aspell
    ptyxis
    muzika
    foliate
    gapless
    inkscape
    r2modman
    pciutils
    resources
    libreoffice
    wl-clipboard
    google-cursor
    prismlauncher
    authenticator
    cinny-desktop
    papirus-icon-theme
    nexusmods-app-unfree
    hunspellDicts.en_CA-large
  ];
}
