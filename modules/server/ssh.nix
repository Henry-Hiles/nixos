{
  users.users.quadradical.openssh.authorizedKeys.keys = import ../../secrets/keys.nix;
  services = {
    openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = false;
        AllowUsers = [ "quadradical" ];
        PermitRootLogin = "no";
      };
    };

    fail2ban = {
      enable = true;
      maxretry = 5;
      ignoreIP = [ "192.168.0.0/16" ];
      bantime = "6h";
      bantime-increment = {
        enable = true;
        formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
        maxtime = "240h";
        overalljails = true;
      };
    };
  };

}
