{
  config,
  pkgs,
  ...
}: {
  services = {
    redlib = {
      enable = true;
      package = pkgs.redlib.overrideAttrs (oldAttrs: {
        doCheck = false;
        src = pkgs.fetchFromGitHub {
          owner = "chowder";
          repo = "redlib";
          rev = "47ef6a06d47416559609c385d5234d155938f3e3";
          hash = "sha256-gsgWqVOUizSYFjSg9x+dG1VRWabvjpuCGjaG94q1cQY=";
        };
      });

      address = "127.0.0.6";
      port = 8082;
      settings.REDLIB_DEFAULT_THEME = "nord";
    };

    caddy.authedHosts."redlib.federated.nexus" = with config.services.redlib; "reverse_proxy ${address}:${toString port}";
  };

  systemd.services.redlib.serviceConfig.Restart = "always";
}
