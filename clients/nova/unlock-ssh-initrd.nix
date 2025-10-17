{ config, ... }:
{
  fileSystems."/".options = [ "x-systemd.device-timeout=0" ];
  networking.firewall.allowedTCPPorts = [ 222 ];
  boot = {
    loader.grub.enable = false;
    initrd = {
      systemd = {
        enable = true;
        users.root.shell = "/bin/systemd-tty-ask-password-agent";
      };
      network.ssh = {
        enable = true;
        port = 222;
        hostKeys = [ "/etc/ssh/ssh_host_ed25519_key_initrd" ];
        authorizedKeys = config.users.users.ava.openssh.authorizedKeys.keys;
      };
    };
  };
}
