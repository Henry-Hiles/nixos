{ pkgs, ... }: {
  environment.systemPackages = [ pkgs.kdePackages.kunifiedpush ];
  systemd.packages = [
    pkgs.kdePackages.kunifiedpush
  ];

  networking.firewall = {
    allowedUDPPorts = [
      8008
    ];
    allowedTCPPorts = [
      8008
    ];
  };
}
