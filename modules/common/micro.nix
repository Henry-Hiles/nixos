{pkgs, ...}: {
  environment = {
    systemPackages = [pkgs.micro];
    sessionVariables.EDITOR = "micro";
  };
}
