{inputs, ...}: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = {inherit inputs;};
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
    ../home-manager/gtk.nix
    ../home-manager/bat.nix
    ../home-manager/eza.nix
    ../home-manager/git.nix
    ../home-manager/btop.nix
    ../home-manager/vscode.nix
    ../home-manager/direnv.nix
    ../home-manager/firefox.nix
    ../home-manager/neofetch.nix
    ../home-manager/mangohud.nix
    ../home-manager/sway.nix
  ];
}
