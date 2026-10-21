{ pkgs, lib, ... }:
{
  programs.steam = {
    enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
    gamescopeSession.enable = true;
  };

  environment.systemPackages = [
    (lib.hiPrio (
      pkgs.makeDesktopItem {
        name = "steam";
        desktopName = "Steam";
        exec = "steam-gamescope";
        icon = "steam";
        categories = [
          "Network"
          "FileTransfer"
          "Game"
        ];
      }
    ))
  ];
}
