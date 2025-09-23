{
  lib,
  pkgs,
  ...
}:
{
  environment.shellAliases.ls = "${lib.getExe pkgs.eza} --all --icons --hyperlink --group-directories-first --color=always";
}
