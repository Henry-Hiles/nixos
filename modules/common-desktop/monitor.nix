{
  pkgs,
  lib,
  ...
}: {
  hardware.i2c.enable = true;
  systemd.services.monitor-off = rec {
    script = "${lib.meta.getExe pkgs.ddcutil} setvcp D6 05";
    wantedBy = ["sleep.target" "poweroff.target"];
    before = wantedBy;

    serviceConfig = {Type = "oneshot";};
  };

  systemd.services.monitor-on = rec {
    script = "${lib.meta.getExe pkgs.ddcutil} setvcp D6 01";
    wantedBy = ["sleep.target" "multi-user.target"];
    after = wantedBy;
  };
}
