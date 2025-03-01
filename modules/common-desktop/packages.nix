{
  pkgs,
  inputs,
  ...
}: {
  services.xserver.excludePackages = [pkgs.xterm];
  environment.systemPackages = with pkgs; [
    fd
    tldr
    tuba
    gimp
    deno
    dart
    ptyxis
    heroic
    aspell
    muzika
    fractal
    killall
    ripgrep
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
    android-studio
    nexusmods-app-unfree
    hunspellDicts.en_CA-large
    inputs.nix-gaming.packages.${system}.wine-ge
  ];
}
