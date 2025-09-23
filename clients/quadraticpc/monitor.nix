{
  pkgs,
  lib,
  ...
}:
let
  setvcp = "${lib.meta.getExe pkgs.ddcutil} setvcp D6";
in
{
  hardware.i2c.enable = true;
  systemd.services = {
    monitor-off = rec {
      script = "${setvcp} 05";
      wantedBy = [
        "sleep.target"
        "final.target"
      ];
      before = wantedBy;

      serviceConfig.Type = "oneshot";
      unitConfig.DefaultDependencies = false;
    };

    monitor-on = rec {
      script = "${setvcp} 01";
      wantedBy = [
        "sleep.target"
        "multi-user.target"
      ];
      after = wantedBy;
    };
  };
}
