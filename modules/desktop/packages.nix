{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    gimp
    gale
    heroic
    inkscape
    libreoffice
    authenticator
    cinny-desktop
    prismlauncher
  ];
}
