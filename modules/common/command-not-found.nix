{
  inputs,
  pkgs,
  ...
}: {
  programs.command-not-found.dbPath = inputs.programsdb.packages.${pkgs.system}.programs-sqlite;
}
