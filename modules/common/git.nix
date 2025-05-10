{pkgs, ...}: {
  programs.git = {
    enable = true;
    config = {
      user = {
        name = "Henry-Hiles";
        email = "henry@henryhiles.com";
        signingKey = builtins.elemAt (import ../../secrets/keys.nix) 0;
      };
      url = {
        "git@github.com:".insteadOf = ["https://github.com/"];
        "git@git.henryhiles.com:".insteadOf = ["https://git.henryhiles.com"];
      };
      init.defaultBranch = "main";
      commit.gpgsign = true;
      pull.rebase = true;
      gpg.format = "ssh";
    };
  };
  environment.systemPackages = [pkgs.gh];
}
