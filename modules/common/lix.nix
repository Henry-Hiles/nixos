{ pkgs, ... }:
{
  nix = {
    package = pkgs.lixPackageSets.latest.lix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
      "flake-self-attrs"
    ];
  };
}
