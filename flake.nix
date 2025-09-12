{
  inputs = {
    gnome-mobile.url = "github:chuangzhu/nixpkgs-gnome-mobile";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs";
    wrapper-manager.url = "github:viperML/wrapper-manager";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nix-maid.url = "github:viperML/nix-maid";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    run0-sudo-shim = {
      url = "github:lordgrimmauld/run0-sudo-shim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    grapevine = {
      url = "gitlab:matrix/grapevine?ref=olivia/openid-api&host=gitlab.computer.surgery";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ooye = {
      url = "git+https://cgit.rory.gay/nix/OOYE-module.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    matrixoidc = {
      url = "git+https://git.federated.nexus/Henry-Hiles/matrixoidc";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lasuite-docs-proxy = {
      url = "git+https://git.federated.nexus/Henry-Hiles/lasuite_docs_proxy";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nexusbot = {
      url = "git+https://git.federated.nexus/federated-nexus/nexusbot";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-matrix-appservices = {
      url = "gitlab:coffeetables/nix-matrix-appservices";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix-cli = {
      url = "github:cole-h/agenix-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };
    sdm845 = {
      url = "github:Henry-Hiles/dotfiles-fork";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    lib = inputs.nixpkgs.lib;
    dirUtils = {
      opt = lib.optionals;
      dirFiles = type: dir: lib.filter (lib.hasSuffix type) (lib.filesystem.listFilesRecursive dir);
    };
    system = info:
      lib.nixosSystem {
        inherit (info) system;
        specialArgs = {
          inherit inputs dirUtils;
          inherit (info) type;

          crossPkgs = import inputs.nixpkgs {
            hostPlatform = info.system;
            localSystem = info.system;
            buildPlatform = "x86_64-linux";

            overlays = let path = ./cross-overlays/${info.hostname}; in dirUtils.opt (builtins.pathExists path) (map (file: import file inputs) (lib.filesystem.listFilesRecursive path));

            config.permittedInsecurePackages = [
              "libsoup-2.74.3"
            ];
          };
        };

        modules = let
          clientPath = ./clients/${info.hostname};
        in
          with dirUtils;
            [
              ./wrappers/default.nix
              {networking.hostName = info.hostname;}
              inputs.agenix.nixosModules.default
              inputs.run0-sudo-shim.nixosModules.default
            ]
            ++ dirFiles ".nix" ./modules/common
            ++ dirFiles ".nix" ./modules/${info.type}
            ++ opt (builtins.pathExists clientPath) (dirFiles ".nix" clientPath)
            ++ opt info.graphical (
              (dirFiles ".nix" ./modules/graphical)
              ++ [
                inputs.home-manager.nixosModules.home-manager
                inputs.nix-maid.nixosModules.default
                inputs.stylix.nixosModules.stylix
                ./stylix.nix
              ]
            );
      };
  in
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["aarch64-linux" "x86_64-linux"];

      perSystem = {pkgs, ...}: {
        formatter = pkgs.alejandra;
        apps.image = {
          type = "app";
          program = pkgs.writeShellApplication {
            name = "image";
            runtimeInputs = with pkgs; [nix-output-monitor];
            text = "nom build .#nixosConfigurations.\"$1\".config.system.build.image";
          };
        };
      };

      flake.nixosConfigurations = builtins.mapAttrs (name: value:
        system (
          {
            system = "x86_64-linux";
            graphical = true;
            hostname = name;
          }
          // value
        )) {
        "quadraticpc".type = "desktop";
        "quadtop".type = "desktop";
        "quadraticserver" = {
          type = "server";
          graphical = false;
        };
        "quadphone" = {
          type = "mobile";
          system = "aarch64-linux";
        };
        "everquad" = {
          type = "mobile";
          system = "aarch64-linux";
        };
      };
    };
}
