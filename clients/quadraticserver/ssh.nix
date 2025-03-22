{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      AllowUsers = ["quadradical"];
      PermitRootLogin = "no";
    };
  };
}
