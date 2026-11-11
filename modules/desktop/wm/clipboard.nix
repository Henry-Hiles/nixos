{ pkgs, lib, ... }:
{
  # Keeps clipboard contents available after the app they were copied from exits
  programs.fht-compositor.sessionPrograms.wl-clip-persist =
    "${lib.getExe pkgs.wl-clip-persist} --clipboard regular";
}
