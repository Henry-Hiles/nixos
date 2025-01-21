{
  pkgs,
  inputs,
  ...
}: {
  programs.gamemode.enable = true;

  services.xserver.excludePackages = [pkgs.xterm];
  environment.systemPackages = with pkgs; [
    fd
    tldr
    tuba
    gimp
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
    nodejs_22
    impression
    libreoffice
    wl-clipboard
    protontricks
    prismlauncher
    android-studio
    nexusmods-app-unfree
    nodePackages_latest.pnpm
    hunspellDicts.en_CA-large
    inputs.nix-gaming.packages.${system}.wine-ge
  ];
}
