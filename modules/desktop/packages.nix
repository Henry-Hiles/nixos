{pkgs, ...}: {
  services.xserver.excludePackages = [pkgs.xterm];
  environment.systemPackages = with pkgs; [
    tuba
    gimp
    deno
    ptyxis
    heroic
    aspell
    muzika
    fractal
    foliate
    inkscape
    r2modman
    pciutils
    resources
    libreoffice
    wl-clipboard
    prismlauncher
    authenticator
    nexusmods-app-unfree
    hunspellDicts.en_CA-large
  ];
}
