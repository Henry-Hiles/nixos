let
  port = 2222;
in {
  networking.firewall.allowedTCPPorts = [port];
  users.users.quadradical.openssh.authorizedKeys.keys = import ../../secrets/keys.nix;
  services.openssh = {
    enable = true;
    ports = [port];
    settings = {
      PasswordAuthentication = false;
      AllowUsers = ["quadradical"];
      PermitRootLogin = "no";
    };
  };
}
