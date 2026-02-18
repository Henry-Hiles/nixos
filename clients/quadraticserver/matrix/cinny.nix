{ pkgs, ... }:
{
  services.caddy.virtualHosts."app.federated.nexus".extraConfig = ''
    root ${
      pkgs.cinny.override {
        conf = {
          defaultHomeserver = 0;
          homeserverList = [ "federated.nexus" ];
          allowCustomHomeservers = false;
        };
        cinny-unwrapped = pkgs.cinny-unwrapped.overrideAttrs (old: rec {
          src = pkgs.fetchFromCodeberg {
            owner = "lapingvino";
            repo = "cinny";
            rev = "7181f6bee47b764107d61b63611a3af8d3bc8a41";
            hash = "sha256-wTPUd/wfyKIHnihan2fChYf0hs0S8JzelhGsR3o4JXg=";
          };
          npmDeps = pkgs.fetchNpmDeps {
            inherit src;
            name = "${old.pname}-${old.version}-npm-deps";
            hash = "sha256-a4cnxo5smN+a6DWKPPkbGkd8gcQe/jazSEmrqKcN0fA=";
          };
        });
      }
    }
    try_files {path} {path}/ /index.html
    file_server
  '';
}
