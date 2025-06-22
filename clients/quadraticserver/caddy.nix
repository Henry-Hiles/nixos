{pkgs, ...}: {
  services.caddy = {
    enable = true;
    email = "henry@henryhiles.com";

    package = pkgs.caddy.withPlugins {
      plugins = ["github.com/ggicci/caddy-jwt@v1.1.0"];
      hash = "sha256-sdhX/dAQ7lIxBo/ZW6XYX8SRuacLO9HobtIVKD/cw0o=";
    };
  };
  networking.firewall.allowedTCPPorts = [2222 443 8448]; # Git SSH, HTTPS, and Matrix
}
