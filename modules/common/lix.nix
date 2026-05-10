{ pkgs, ... }:
{
  nix = {
    package = pkgs.lix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
      "flake-self-attrs"
    ];
  };
}
