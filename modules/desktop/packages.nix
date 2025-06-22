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
    prismlauncher
    authenticator
    cinny-desktop
    # nexusmods-app-unfree
    hunspellDicts.en_CA-large
  ];
}
