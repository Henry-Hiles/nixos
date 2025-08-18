{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    gimp
    heroic
    inkscape
    r2modman
    libreoffice
    authenticator
    cinny-desktop
    prismlauncher
    nexusmods-app-unfree
  ];
}
