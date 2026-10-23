{
  config,
  pkgs,
  lib,
  ...
}:
let
  steam = lib.getExe config.programs.steam.package;
in
{
  programs.steam = {
    enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };

  # Wrap `steam` so everything (including the desktop files steam creates for games) launches inside gamescope
  environment.systemPackages = [
    (lib.hiPrio (
      pkgs.writeShellScriptBin "steam" ''
        # If steam is already running, just hand the args (e.g. steam://rungameid/...) to it
        pid=$(cat "$HOME/.steam/steam.pid" 2>/dev/null)
        if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
          exec ${steam} "$@"
        fi

        exec gamescope --steam -- ${steam} -tenfoot -pipewire-dmabuf "$@"
      ''
    ))
  ];
}
