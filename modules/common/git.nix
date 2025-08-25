{
  pkgs,
  lib,
  ...
}: {
  programs.git = {
    enable = true;
    config = {
      user = {
        name = "Henry-Hiles";
        email = "henry@henryhiles.com";
        signingKey = builtins.elemAt (import ../../secrets/keys.nix) 0;
      };
      url = {
        "git@github.com:".insteadOf = ["https://github.com"];
        "git@codeberg.org:".insteadOf = ["https://codeberg.org"];
        "git@git.federated.nexus:".insteadOf = ["https://git.federated.nexus"];
      };
      init.defaultBranch = "main";
      commit.gpgsign = true;
      pull.rebase = true;
      gpg.format = "ssh";
    };
  };
  environment = {
    systemPackages = [pkgs.gh];
    shellAliases = let
      gitExe = lib.meta.getExe pkgs.git;
      ghExe = lib.meta.getExe pkgs.gh;
    in {
      clone = "${ghExe} repo clone";
      create = "${ghExe} repo create";

      push = "${gitExe} push";
      commit = "${gitExe} commit -am";
    };
  };
}
