{
  inputs = {
    gnome-mobile.url = "github:chuangzhu/nixpkgs-gnome-mobile";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-goolm.url = "github:Henry-Hiles/nixpkgs?ref=mautrix-gmessages-goolm";
    wrapper-manager.url = "github:viperML/wrapper-manager";
    flake-parts.url = "github:hercules-ci/flake-parts";
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
    programsdb = {
      url = "github:wamserma/flake-programs-sqlite";
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
        specialArgs = {
          inherit inputs dirUtils;
          isDesktop = info.isDesktop or false;
        };

        modules = with dirUtils;
          [
            ./wrappers/default.nix
            {networking.hostName = info.hostname;}
            inputs.agenix.nixosModules.default
            inputs.run0-sudo-shim.nixosModules.default
          ]
          ++ dirFiles ".nix" ./clients/${info.hostname}
          ++ dirFiles ".nix" ./modules/common
          ++ opt (info.isServer or false) (dirFiles ".nix" ./modules/server)
          ++ opt (info.isDesktop or false) (dirFiles ".nix" ./modules/desktop)
          ++ opt (info.isGraphical or info.isDesktop or false) (
            (dirFiles ".nix" ./modules/graphical)
            ++ [
              inputs.home-manager.nixosModules.home-manager
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
      };

      flake.nixosConfigurations = builtins.mapAttrs (name: value: system (value // {hostname = name;})) {
        "quadraticpc".isDesktop = true;
        "quadtop".isDesktop = true;
        "quadraticserver".isServer = true;
        "quadphone".isGraphical = true;
      };
    };
}
