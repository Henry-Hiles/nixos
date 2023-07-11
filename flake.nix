{
  inputs = {
    stylix.url = "github:danth/stylix";
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-unstable";
    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };
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
    nixpkgs,
    home-manager,
    stylix,
    self,
    ...
  } @ inputs: let
    system = hostname:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          inherit self;
        };
        modules =
          [
            "${self}/${hostname}/configuration.nix"
            "${self}/${hostname}/hardware-configuration.nix"
            ./common.nix
          ]
          ++ nixpkgs.lib.optionals (builtins.pathExists "${self}/${hostname}/home-manager.nix") [
            home-manager.nixosModules.home-manager
            "${self}/${hostname}/home-manager.nix"
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
