{
  config,
  inputs,
  pkgs,
  ...
}:
{
  services = {
    redlib = {
      enable = true;
      address = "127.0.0.6";
      port = 8082;
      settings.REDLIB_DEFAULT_THEME = "nord";

      package = pkgs.redlib.overrideAttrs (oldAttrs: rec {
        doCheck = false;
        src = inputs.redlib;

        nativeBuildInputs =
          (oldAttrs.nativeBuildInputs or [ ])
          ++ (with pkgs; [
            cmake
            go
            perl
            git
            rustPlatform.bindgenHook
          ]);

        cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
          inherit src;
          hash = "sha256-eO3c7rlFna3DuO31etJ6S4c7NmcvgvIWZ1KVkNIuUqQ=";
        };
      });
    };

    caddy.authedHosts."redlib.federated.nexus" =
      with config.services.redlib;
      "reverse_proxy ${address}:${toString port}";
  };

  systemd.services.redlib.serviceConfig.Restart = "always";
}
