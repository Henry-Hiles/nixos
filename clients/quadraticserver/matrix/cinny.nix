{ pkgs, ... }:
{
  services.caddy.virtualHosts =
    let
      mkCinny = override: {
        extraConfig = ''
          root ${
            pkgs.cinny.override {
              conf = {
                defaultHomeserver = 0;
                homeserverList = [ "federated.nexus" ];
                allowCustomHomeservers = false;
              };
              cinny-unwrapped = pkgs.cinny-unwrapped.overrideAttrs override;
            }
          }
          try_files {path} {path}/ /index.html
          file_server
        '';
      };
    in
    {
      "app.federated.nexus" = mkCinny (old: rec {
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

      "staging.app.federated.nexus" = mkCinny (old: rec {
        src = pkgs.fetchFromCodeberg {
          owner = "lapingvino";
          repo = "cinny";
          rev = "8228227f64cf22c8cda2bc7cea1d5948d007822b";
          hash = "sha256-JcZ2jhKrxwtzbnhvCAS4yVF788TmocYoIOFJsV0QdbU=";
        };
        npmDeps = pkgs.fetchNpmDeps {
          inherit src;
          name = "${old.pname}-${old.version}-npm-deps";
          hash = "sha256-RZEQojhMpwimws5eQj/eCMs/rDSfvtlQmLRpd+scv8g=";
        };
      });
    };
}
