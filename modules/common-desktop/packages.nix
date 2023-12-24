{pkgs, inputs, ...}: {
  environment.systemPackages = with pkgs; [
    fd
    tldr
    tuba
    gimp
    heroic
    aspell
    killall
    ripgrep
    hyfetch
    inkscape
    r2modman
    pciutils
    monophony
    alejandra
    grapejuice
    impression
    libreoffice
    virt-manager
    wl-clipboard
    protontricks
    android-studio
    hunspellDicts.en_CA-large
    inputs.nix-gaming.packages.${system}.wine-ge
  ];
}
