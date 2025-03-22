{pkgs, ...}: {
  services.xserver.excludePackages = [pkgs.xterm];
  environment.systemPackages = with pkgs; [
    tuba
    gimp
    deno
    dart
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
    alejandra
    impression
    libreoffice
    wl-clipboard
    protontricks
    prismlauncher
    authenticator
    android-studio
    nexusmods-app-unfree
    hunspellDicts.en_CA-large
  ];
}
