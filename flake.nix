{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    agenix = {
      url = "github:Henry-Hiles/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
    nix-gaming.url = "github:fufexan/nix-gaming";
    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };
    programsdb = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wrapper-manager = {
      url = "github:viperML/wrapper-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    lib = inputs.nixpkgs.lib;
    dirUtils = {
      opt = inputs.nixpkgs.lib.optionals;
      dirFiles = type: dir: lib.filter (lib.hasSuffix type) (lib.filesystem.listFilesRecursive dir);
    };
    system = hostname: isDesktop:
      inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs isDesktop dirUtils;
        };

        modules = with dirUtils;
          [
            ./wrappers
            inputs.agenix.nixosModules.default
            inputs.nix-gaming.nixosModules.pipewireLowLatency
          ]
          ++ dirFiles ".nix" "${inputs.self}/${hostname}"
          ++ dirFiles ".nix" ./modules/common
          ++ opt isDesktop (
            (dirFiles ".nix" ./modules/common-desktop)
            ++ [
              inputs.stylix.nixosModules.stylix
              ./stylix.nix

              inputs.home-manager.nixosModules.home-manager
              ./home-manager.nix
            ]
          );
      };
  in {
    nixosConfigurations = {
      "quadraticpc" = system "quadraticpc" true;
      "quadtop" = system "quadtop" true;
    };

    formatter.x86_64-linux = inputs.nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
