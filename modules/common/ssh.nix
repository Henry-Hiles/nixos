{ config, lib, ... }:
{
  options.quad.ssh.enable = lib.mkEnableOption "the SSH server, with key-only login as quadradical";

  config = lib.mkIf config.quad.ssh.enable {
    users.users.quadradical.openssh.authorizedKeys.keys = import ../../secrets/keys.nix;
    services.openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = false;
        AllowUsers = [ "quadradical" ];
        PermitRootLogin = "no";
      };
    };
  };
}
