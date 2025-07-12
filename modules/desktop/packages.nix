{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    gimp
    heroic
    inkscape
    r2modman
    libreoffice
    cinny-desktop
    prismlauncher
    nexusmods-app-unfree
  ];
}
