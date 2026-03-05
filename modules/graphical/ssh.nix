{
  programs.ssh.extraConfig = ''
    Host server
      HostName ssh.federated.nexus
      Port 2222
    Host phone
      HostName 172.16.42.1
  '';
}
