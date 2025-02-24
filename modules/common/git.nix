{pkgs, ...}: {
  programs.git = {
    enable = true;
    config.user = {
      name = "Henry-Hiles";
      email = "henry@henryhiles.com";
    };
  };

  environment.systemPackages = [pkgs.git-credential-manager];
}
