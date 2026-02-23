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
            rev = "6af88b792f967603552044ff0427412fcd87290b";
            hash = "sha256-XzhtIE5LNcSwJ+un1PtR2EnWOt9PPY0Eu5c2XjAiEaA=";
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
