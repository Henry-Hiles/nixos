{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.quadradical = {
    home = {
      username = "quadradical";
      homeDirectory = "/home/quadradical";
    };
  };
  home-manager.sharedModules = [
    {
      programs.home-manager.enable = true;
      home.stateVersion = "23.11";
    }
    ../home-manager/bat.nix
	../home-manager/exa.nix
    ../home-manager/git.nix
    ../home-manager/btop.nix
    ../home-manager/vscode.nix
  ];
}
