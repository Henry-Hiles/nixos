{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # FIXME: pinned for lasuite-docs 5.7.0 until migrated to 6.x
    nixpkgs-lasuite.url = "github:nixos/nixpkgs/1d060086d60cb76a40cf37109f979d88a5bd6396";
    wrapper-manager.url = "git+https://codeberg.org/viperML/wrapper-manager";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nix-maid.url = "git+https://codeberg.org/viperML/nix-maid";
    gadgetfs = {
      url = "github:sorki/nixos-gadgetfs-proto";
      flake = false;
    };
    gnome-mobile = {
      url = "git+file:///home/quadradical/Documents/Code/nixos-gnome-mobile";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixphone = {
      url = "git+https://codeberg.org/nixphone/nixphone";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    continuwuity = {
      url = "git+file:///home/quadradical/Documents/Code/continuwuity";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    run0-sudo-shim = {
      url = "github:lordgrimmauld/run0-sudo-shim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sable = {
      url = "github:sableclient/sable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sable-next = {
      url = "git+https://git.sable.moe/SableClient/sable-next";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    matrixoidc = {
      url = "git+https://git.federated.nexus/Henry-Hiles/matrixoidc";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nexus = {
      url = "git+https://git.federated.nexus/Nexus/nexus";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lasuite-docs-proxy = {
      url = "git+https://git.federated.nexus/Henry-Hiles/lasuite_docs_proxy";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cozybot = {
      url = "git+https://git.federated.nexus/Henry-Hiles/cozybot";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nexusbot = {
      url = "git+https://git.federated.nexus/federated-nexus/nexusbot";
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
    degoog = {
      url = "github:degoog-org/degoog";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fht-compositor = {
      url = "github:nferhat/fht-compositor";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "";
      };
    };
    gaypanel = {
      url = "git+https://codeberg.org/pastthepixels/gaypanel";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };
    redlib = {
      url = "github:Nachtalb/redlib";
      flake = false;
    };
    # TODO: remove once https://github.com/NixOS/nixpkgs/pull/548367 is merged
    lk-jwt-service-module = {
      url = "file+https://raw.githubusercontent.com/j0hax/nixpkgs/lk-jwt-service-restructure/nixos/modules/services/matrix/lk-jwt-service.nix";
      flake = false;
    };
  };

  outputs =
    inputs:
    let
      lib = inputs.nixpkgs.lib;
      dirUtils = {
        opt = lib.optionals;
        dirFiles = type: dir: lib.filter (lib.hasSuffix type) (lib.filesystem.listFilesRecursive dir);
      };
      system =
        info:
        lib.nixosSystem {
          inherit (info) system;
          specialArgs = {
            inherit inputs dirUtils;
            inherit (info) type;
          };

          modules =
            let
              clientPath = ./clients/${info.hostname};
            in
            with dirUtils;
            [
              ./wrappers/default.nix
              { networking.hostName = info.hostname; }
            ]
            ++ dirFiles ".nix" ./modules/common
            ++ dirFiles ".nix" ./modules/${info.type}
            ++ opt (builtins.pathExists clientPath) (dirFiles ".nix" clientPath)
            ++ opt info.graphical (dirFiles ".nix" ./modules/graphical);
        };
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];

      perSystem =
        { pkgs, ... }:
        {
          apps.image = {
            type = "app";
            program = pkgs.writeShellApplication {
              name = "image";
              runtimeInputs = with pkgs; [ nix-output-monitor ];
              text = "nom build .#nixosConfigurations.\"$1\".config.system.build.image";
            };
          };
        };

      flake.nixosConfigurations =
        builtins.mapAttrs
          (
            name: value:
            system (
              {
                system = "x86_64-linux";
                graphical = true;
                hostname = name;
              }
              // value
            )
          )
          {

            quadraticpc.type = "desktop";
            quadtop.type = "desktop";
            quadphone = {
              type = "mobile";
              system = "aarch64-linux";
            };
            quadraticserver = {
              type = "server";
              graphical = false;
            };
          };
    };
}
