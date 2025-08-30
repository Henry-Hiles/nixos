{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    gimp
    gale
    heroic
    inkscape
    libreoffice
    authenticator
    prismlauncher
    cinny-desktop
  ];
}
