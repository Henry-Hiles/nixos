{
  users.users.quadradical.openssh.authorizedKeys.keys = import ../../secrets/keys.nix;
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      AllowUsers = ["quadradical"];
      PermitRootLogin = "no";
    };
  };
}
