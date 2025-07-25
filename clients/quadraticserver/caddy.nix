{pkgs, ...}: {
  networking.firewall.allowedTCPPorts = [443];
  services.caddy = {
    enable = true;
    email = "hen" + "ry@he" + "nryhi" + "les.c" + "om";

    package = pkgs.caddy.withPlugins {
      plugins = ["github.com/ggicci/caddy-jwt@v1.1.0"];
      hash = "sha256-sdhX/dAQ7lIxBo/ZW6XYX8SRuacLO9HobtIVKD/cw0o=";
    };
  };
}
# WAF demo
# {
#   config,
#   pkgs,
#   lib,
#   ...
# }: {
#   config = {
#     networking.firewall.allowedTCPPorts = [443];
#     services.caddy = {
#       enable = true;
#       email = "henry@henryhiles.com";
#       globalConfig = "order coraza_waf first";
#       virtualHosts = lib.mapAttrs (_: hostCfg:
#         hostCfg
#         // {
#           extraConfig = ''
#             route {
#               coraza_waf {
#                 load_owasp_crs
#                 directives `
#                   Include @coraza.conf-recommended
#                   Include @crs-setup.conf.example
#                   Include @owasp_crs/*.conf
#                   SecRuleRemoveById 920420
#                   SecRuleRemoveById 911100
#                   SecRuleEngine On
#                 `
#               }
#             }
#             ${hostCfg.extraConfig or ""}
#           '';
#         })
#       config.services.caddy.wafHosts;
#       package = pkgs.caddy.withPlugins {
#         plugins = ["github.com/ggicci/caddy-jwt@v1.1.0" "github.com/corazawaf/coraza-caddy/v2@v2.1.0"];
#         hash = "sha256-1TmIs8CWMlNHF4NRqj7/W/pqRUIpcOFbJGALqPINVtk=";
#       };
#     };
#   };
#   options.services.caddy.wafHosts = lib.mkOption {
#     type = lib.types.attrsOf (lib.types.submodule {
#       options.extraConfig = lib.mkOption {
#         type = lib.types.lines;
#         default = "";
#       };
#     });
#     default = {};
#   };
# }

