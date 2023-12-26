{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    stylix.url = "github:danth/stylix";
    nixpkgs-local.url = "git+file:/home/quadradical/Documents/Code/nixpkgs?branch=init-monophony";
    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };
    nix-gaming.url = "github:fufexan/nix-gaming";
    programsdb = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wrapper-manager = {
      url = "github:viperML/wrapper-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # wrapper-manager-hm-compat = {
    #   url = "github:nrabulinski/wrapper-manager-hm-compat";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.home-manager.follows = "home-manager";
    # };
  };

  outputs = {
    self,
    stylix,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    dirUtils = {
      opt = nixpkgs.lib.optionals;
      dirFiles = dir: map (file: "${dir}/${file}") (builtins.attrNames (builtins.readDir dir));
    };
    system = hostname: isDesktop:
      with dirUtils;
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs self isDesktop dirUtils;
          };

          modules =
            [
              ./wrappers
              "${self}/${hostname}/configuration.nix"
              "${self}/${hostname}/hardware-configuration.nix"
              inputs.nix-gaming.nixosModules.pipewireLowLatency
            ]
            ++ dirFiles ./modules/common
            ++ opt isDesktop (
              (dirFiles ./modules/common-desktop)
              ++ [
                stylix.nixosModules.stylix
                ./stylix.nix

                home-manager.nixosModules.home-manager
                ./home-manager.nix
              ]
            );
        };
  in {
    nixosConfigurations = {
      "quadraticpc" = system "quadraticpc" true;
      "quadtop" = system "quadtop" true;
    };

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
