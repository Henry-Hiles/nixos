{
  lib,
  pkgs,
  ...
}:
{
  environment.shellAliases.cat = "${lib.getExe pkgs.bat} --theme Nord";
}
