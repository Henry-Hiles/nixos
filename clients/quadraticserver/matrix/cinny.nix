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
            rev = "719381934efbe3aab098d4f077ec4ee14a30eddb";
            hash = "";
          };
          npmDeps = pkgs.fetchNpmDeps {
            inherit src;
            name = "${old.pname}-${old.version}-npm-deps";
            hash = "";
          };
        });
      }
    }
    try_files {path} {path}/ /index.html
    file_server
  '';
}
