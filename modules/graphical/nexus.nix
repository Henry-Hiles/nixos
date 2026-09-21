{ inputs, ... }: {
  imports = [ inputs.nexus.nixosModules.default ];

  programs.nexus = {
    enable = true;
    enableNotifications = true;
  };
}
