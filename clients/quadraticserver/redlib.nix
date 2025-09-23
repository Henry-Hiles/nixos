{
  config,
  pkgs,
  ...
}:
{
  services = {
    redlib = {
      enable = true;
      package = pkgs.redlib.overrideAttrs (oldAttrs: {
        doCheck = false;
        src = pkgs.fetchFromGitHub {
          owner = "redlib-org";
          repo = "redlib";
          rev = "a989d19ca92713878e9a20dead4252f266dc4936";
          hash = "sha256-YJZVkCi8JQ1U47s52iOSyyf32S3b35pEqw4YTW8FHVY=";
        };
      });

      address = "127.0.0.6";
      port = 8082;
      settings.REDLIB_DEFAULT_THEME = "nord";
    };

    caddy.authedHosts."redlib.federated.nexus" =
      with config.services.redlib;
      "reverse_proxy ${address}:${toString port}";
  };

  systemd.services.redlib.serviceConfig.Restart = "always";
}
