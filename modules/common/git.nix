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
      pull.rebase = true;
      gpg = {
        format = "ssh";
        ssh.allowedSignersFile = pkgs.writeText "allowedSigners" "henry@henryhiles.com ${builtins.elemAt (import ../../secrets/keys.nix) 0}";
      };
    };
  };
  #test
  environment.systemPackages = [pkgs.gh];
}
