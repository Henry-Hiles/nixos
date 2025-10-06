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
            owner = "gingershaped";
            repo = "cinny";
            rev = "13dd8fcc0696d18e2af0f8eed234ff64660f402e";
            hash = "sha256-AHKiqXmL5J7Yt8hxjdgJJQwOYwKwSyDNfJxvuyMG13s=";
          };
          npmDeps = pkgs.fetchNpmDeps {
            inherit src;
            name = "${old.pname}-${old.version}-npm-deps";
            hash = "sha256-lBt42rKqNpdpfQt0YlZoxFa9W+1LbY33Uitknsizrng=";
          };
        });
      }
    }
    try_files {path} {path}/ /index.html
    file_server
  '';
}
