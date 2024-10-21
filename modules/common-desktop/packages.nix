{
  pkgs,
  inputs,
  ...
}: {
  programs.gamemode.enable = true;
  environment.systemPackages = with pkgs; [
    fd
    tldr
    tuba
    gimp
    dart
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
    alejandra
    nodejs_22
    impression
    libreoffice
    wl-clipboard
    protontricks
    prismlauncher
    android-studio
    mission-center
    nodePackages_latest.pnpm
    hunspellDicts.en_CA-large
    inputs.nix-gaming.packages.${system}.wine-ge
    (retroarch.override {cores = with libretro; [bsnes-hd];})
  ];
}
