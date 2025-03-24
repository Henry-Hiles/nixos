{pkgs, ...}: {
  programs.git = {
    enable = true;
    config = {
      user = {
        name = "Henry-Hiles";
        email = "henry@henryhiles.com";
        signingKey = builtins.elemAt (import ../../secrets/keys.nix) 0;
      };
      commit.gpgsign = true;
      gpg.format = "ssh";
    };
  };

  environment.systemPackages = [pkgs.gh];
}
