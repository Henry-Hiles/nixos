{pkgs, ...}: {
  wrappers.eza = {
    basePackage = pkgs.eza;
    flags = [
      "--all"
      "--icons"
      "--color=always"
      "--group-directories-first"
    ];
  };
}
