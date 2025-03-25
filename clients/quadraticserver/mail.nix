{
  config,
  inputs,
  ...
}: {
  # imports = [inputs.simple-nixos-mailserver.nixosModule];

  # mailserver = {
  #   enable = true;
  #   fqdn = "mail2.henryhiles.com";
  #   domains = ["mail2.henryhiles.com"];

  #   loginAccounts = {
  #     "henry@henryhiles.com" = {
  #       hashedPasswordFile = config.age.secrets."mailPassword.age".path;
  #       aliases = ["contact@henryhiles.com"];
  #     };
  #   };

  #   certificateScheme = "acme";
  # };

  # services.caddy.virtualHosts."mail2.henryhiles.com" = {}; # To get Let's Encrypt cert
}
