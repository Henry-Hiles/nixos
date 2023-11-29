{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stylix.url = "github:danth/stylix";
    nixpkgs-local.url = "git+file:/home/quadradical/Documents/Code/nixpkgs?branch=init-monophony";
    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };
    nix-gaming.url = "github:fufexan/nix-gaming";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    programsdb = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    stylix,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    system = hostname:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs self;
        };
        modules =
          [
            ./common.nix
            "${self}/${hostname}/configuration.nix"
            "${self}/${hostname}/hardware-configuration.nix"
            inputs.nix-gaming.nixosModules.pipewireLowLatency
          ]
          ++ nixpkgs.lib.optionals (builtins.pathExists "${self}/${hostname}/home-manager.nix") [
            "${self}/${hostname}/home-manager.nix"
            home-manager.nixosModules.home-manager
          ]
          ++ nixpkgs.lib.optionals (builtins.pathExists "${self}/${hostname}/stylix.nix") [
            stylix.nixosModules.stylix
            "${self}/${hostname}/stylix.nix"
          ];
      };
  in {
    nixosConfigurations = {
      "quadraticpc" = system "quadraticpc";
    };

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
