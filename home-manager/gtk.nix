{
  pkgs,
  inputs,
  ...
}: {
  gtk = {
    enable = true;

    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };

    cursorTheme = {
      name = "GoogleDot-Blue";
      package = inputs.nixpkgs-google.legacyPackages.x86_64-linux.google-cursor;
    };
  };
}
