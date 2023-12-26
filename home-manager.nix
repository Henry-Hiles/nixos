{inputs, ...}: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
    users.quadradical = {
      home = {
        username = "quadradical";
        homeDirectory = "/home/quadradical";
      };
    };
    sharedModules = [
      {home.stateVersion = "23.11";}
      ./home-manager/gtk.nix
      ./home-manager/bat.nix
      ./home-manager/eza.nix
      ./home-manager/git.nix
      ./home-manager/btop.nix
      ./home-manager/vscode.nix
      ./home-manager/firefox.nix
      ./home-manager/mangohud.nix
      ./home-manager/sway.nix
    ];
  };
}
