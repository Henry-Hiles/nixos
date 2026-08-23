{ pkgs, ... }: {
  environment.systemPackages = [ pkgs.kdePackages.kunifiedpush ];
  systemd.packages = [
    pkgs.kdePackages.kunifiedpush
  ];
}
