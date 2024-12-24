{
  pkgs,
  lib,
  ...
}: {
  hardware.i2c.enable = true;
  systemd.services.monitor = {
    script = "if [[ $(${pkgs.coreutils}/bin/date +%H) -ge 20 ]]; then ${lib.meta.getExe pkgs.ddcutil} setvcp D6 05; fi";
    wantedBy = ["suspend.target" "shutdown.target"];
    before = ["suspend.target" "shutdown.target"];

    serviceConfig = {
      StopWhenUnneeded = true;
      Type = "oneshot";
    };
  };
}
