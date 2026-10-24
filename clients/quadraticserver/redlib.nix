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
          hash = "sha256-XgHXqH4EF8TEOI+cKJ0Z2j6QYRCwGgv8bmY8gZpPN9c=";
        };
      });
    };

    caddy.authedHosts."redlib.federated.nexus" =
      with config.services.redlib;
      "reverse_proxy ${address}:${toString port}";
  };

  systemd.services.redlib.serviceConfig.Restart = "always";
}
