{
  users.users.quadradical.openssh.authorizedKeys.keys = import ../../secrets/keys.nix;
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true; # TODO: False
      AllowUsers = ["quadradical"];
      PermitRootLogin = "no";
    };
  };
}
