{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    gimp
    heroic
    inkscape
    r2modman
    libreoffice
    prismlauncher
    nexusmods-app-unfree
  ];
}
