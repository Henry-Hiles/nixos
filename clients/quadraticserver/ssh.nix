{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      AllowUsers = ["quadradical"];
      PermitRootLogin = "no";
    };
  };
}
