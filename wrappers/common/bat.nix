{pkgs, ...}: {
  wrappers.bat = {
    basePackage = pkgs.bat;
    flags = ["--theme=Nord"];
  };
}
