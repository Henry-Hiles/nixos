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
            rev = "e612663520f7f880e4c193a0b4aaca3d99e1bade";
            hash = "sha256-sShOLXd/L4NDCHOUap09JJ8V7voxKrehx//9sh2xugw=";
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
