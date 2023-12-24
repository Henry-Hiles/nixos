{
  inputs,
  pkgs,
  ...
}: {
  programs.command-not-found.dbPath = "/etc/programs.sqlite";
  environment.etc."programs.sqlite".source = inputs.programsdb.packages.${pkgs.system}.programs-sqlite;
}
