{ pkgs, inputs, ... }:
{
  services.caddy.virtualHosts =
    let
      mkCinny = package: {
        extraConfig = ''
          root ${
            pkgs.cinny.override {
              conf = {
                defaultHomeserver = 0;
                homeserverList = [ "federated.nexus" ];
                allowCustomHomeservers = false;

                disableAccountSwitcher = true;

                featuredCommunities = {
                  spaces = { };
                  rooms = { };
                };
              };
              cinny-unwrapped = package;
            }
          }
          try_files {path} {path}/ /index.html
          file_server
        '';
      };
    in
    {
      "app.federated.nexus" =
        mkCinny
          inputs.nixpkgs-sable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.sable-unwrapped;

      "staging.app.federated.nexus" =
        mkCinny
          inputs.nixpkgs-sable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.sable-unwrapped;
    };
}
