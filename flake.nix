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
    system = hostname: isDesktop: let
      opt = nixpkgs.lib.optionals;
      dirFiles = dir: map (file: "${dir}/${file}") (builtins.attrNames (builtins.readDir dir));
      hostHasFile = file: (builtins.pathExists "${self}/${hostname}/${file}");
    in
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs self;
        };

        modules =
          [
            "${self}/${hostname}/configuration.nix"
            "${self}/${hostname}/hardware-configuration.nix"
            inputs.nix-gaming.nixosModules.pipewireLowLatency
          ]
          ++ dirFiles ./modules/common
          ++ opt isDesktop dirFiles ./modules/common-desktop
          ++ opt (hostHasFile "home-manager.nix") [
            home-manager.nixosModules.home-manager
            "${self}/${hostname}/home-manager.nix"
          ]
          ++ opt (hostHasFile "stylix.nix") [
            stylix.nixosModules.stylix
            "${self}/${hostname}/stylix.nix"
          ];
      };
  in {
    nixosConfigurations = {
      "quadraticpc" = system "quadraticpc" true;
      "quadtop" = system "quadtop" true;
    };

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
