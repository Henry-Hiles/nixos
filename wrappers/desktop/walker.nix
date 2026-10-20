{ pkgs, ... }:
{
  wrappers.walker = {
    basePackage = pkgs.walker;
    # Walker refuses to run unless elephant is in PATH
    pathAdd = [ pkgs.elephant ];
  };
}
