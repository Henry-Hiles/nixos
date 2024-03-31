{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    fd
    tldr
    tuba
    gimp
    heroic
    aspell
    fractal
    killall
    ripgrep
    inkscape
    r2modman
    pciutils
    monophony
    alejandra
    nodejs_21
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
    inputs.bluebuild.packages.${system}.bluebuild
    (retroarch.override {cores = with libretro; [bsnes-hd];})
  ];
}
