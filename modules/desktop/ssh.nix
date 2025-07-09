{
  programs.ssh.extraConfig = ''
    Host server
      HostName ssh.federated.nexus
      Port 2222
  '';
}
