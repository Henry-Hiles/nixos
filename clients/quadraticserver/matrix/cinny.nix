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
        # cinny-unwrapped = pkgs.cinny-unwrapped.overrideAttrs (old: rec {
        #   src = pkgs.fetchFromGitHub {
        #     owner = "GigiaJ";
        #     repo = "cinny";
        #     rev = "a299e9c4cb4df1a3b732fdfddb1297170251a10d";
        #     hash = "sha256-EDsDVOlaYT0S30Cml+t71U7OOKkfcE4aJxwE8iTdV3s=";
        #   };
        #   npmDeps = pkgs.fetchNpmDeps {
        #     inherit src;
        #     name = "${old.pname}-${old.version}-npm-deps";
        #     hash = "sha256-k8eCQO1uIpoKpLHO3E3EYWbQSjcAya2AxngA9mvSfns=";
        #   };
        # });
      }
    }
    try_files {path} {path}/ /index.html
    file_server
  '';
}
