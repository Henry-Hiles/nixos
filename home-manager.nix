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
      ./home-manager/vscode.nix
      ./home-manager/firefox.nix
	    {stylix.targets.hyprland.enable = false;}
    ];
  };
}
