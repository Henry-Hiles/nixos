{
  config,
  pkgs,
  ...
}:
{
  services = {
    redlib = {
      enable = true;
      package = pkgs.redlib.overrideAttrs (oldAttrs: rec {
        doCheck = false;
        src = pkgs.fetchFromGitHub {
          owner = "Silvenga";
          repo = "redlib";
          rev = "9e1c09610cdcb073d16559713dee6409d1a08b20";
          hash = "sha256-ERTEoT7w8oGA0ztrzc9r9Bl/7OOay+APg3pW+h3tgvM=";
        };

        cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
          inherit src;
          hash = "sha256-ageSjIX0BLVYlLAjeojQq5N6/VASOIpwXNR/3msl/p4=";
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
