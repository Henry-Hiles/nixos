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
            rev = "d5ba8537a418a0950adad6f7c4f488078dff6a13";
            hash = "sha256-+WOpBpSzXgBbG5RyMotvJWauPOKjbSI7X6XaRNssd/I=";
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
