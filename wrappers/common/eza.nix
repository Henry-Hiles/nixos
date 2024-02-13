{pkgs, ...}: {
  wrappers.eza = {
    basePackage = pkgs.eza;
    flags = [
      "--all"
      "--icons"
      "--hyperlink"
      "--color=always"
      "--group-directories-first"
    ];
  };
}
