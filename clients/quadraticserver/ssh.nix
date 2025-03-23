{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true; # TODO: False
      AllowUsers = ["quadradical"];
      PermitRootLogin = "no";
    };
  };
}
