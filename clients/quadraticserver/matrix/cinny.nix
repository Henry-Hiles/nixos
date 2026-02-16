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
          src = pkgs.fetchFromGitHub {
            owner = "cinnyapp";
            repo = "cinny";
            tag = "v4.10.3";
            hash = "sha256-ZztZ/znJUwgYlvv5h9uxNZvQrkUMVbMG6R+HbRtSXHM=";
          };
          npmDeps = pkgs.fetchNpmDeps {
            inherit src;
            name = "${old.pname}-${old.version}-npm-deps";
            hash = "sha256-Spt2+sQcoPwy1tU8ztqJHZS9ITX9avueYDVKE7BFYy4=";
          };
        });
      }
    }
    try_files {path} {path}/ /index.html
    file_server
  '';
}
