{ pkgs, lib, ... }:
{
  systemd.user.services.wl-clip-persist = {
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${lib.getExe pkgs.wl-clip-persist} --clipboard regular";
      Restart = "on-failure";
    };
  };
}
