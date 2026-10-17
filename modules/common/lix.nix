{ pkgs, ... }:
{
  nix = {
    package = pkgs.lixPackageSets.lix_2_96.lix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
      "flake-self-attrs"
    ];
  };
}
