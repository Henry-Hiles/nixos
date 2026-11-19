{ pkgs, ... }:
let
  # Sets VCP 0xD6 (power mode) on every display: 01 = on, 05 = off (even monitors that say they don't support it are usually lying)
  monitor-power = pkgs.writeShellApplication {
    name = "monitor-power";
    runtimeInputs = with pkgs; [
      ddcutil
      gnugrep
      coreutils
    ];
    text = ''
      for bus in $(ddcutil detect --terse | grep -oP '/dev/i2c-\K\d+'); do
        (for _ in 1 2 3 4 5; do ddcutil --bus "$bus" setvcp D6 "$1" && break; sleep 1; done) &
      done
      wait
    '';
  };
in
{
  hardware.i2c.enable = true;
  environment.systemPackages = [
    pkgs.ddcutil
    monitor-power
  ];

  systemd.services =
    let
      # ddcutil refuses to start without a cache dir, and services have no HOME
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        CacheDirectory = "ddcutil";
        Environment = "XDG_CACHE_HOME=/var/cache";
      };
    in
    {
      monitor-power = {
        wantedBy = [ "multi-user.target" ];
        after = [ "systemd-modules-load.service" ];
        # Otherwise every rebuild that touches this unit blinks the monitors
        restartIfChanged = false;
        serviceConfig = serviceConfig // {
          ExecStart = "${monitor-power}/bin/monitor-power 01";
          ExecStop = "${monitor-power}/bin/monitor-power 05";
        };
      };

      monitor-power-sleep = {
        wantedBy = [ "sleep.target" ];
        before = [ "sleep.target" ];
        unitConfig.StopWhenUnneeded = true;
        serviceConfig = serviceConfig // {
          ExecStart = "${monitor-power}/bin/monitor-power 05";
          ExecStop = "${monitor-power}/bin/monitor-power 01";
        };
      };
    };
}
