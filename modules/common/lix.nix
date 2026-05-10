{ inputs, pkgs, ... }:
{
  nix = {
    package = inputs.nixpkgs-master.legacyPackages.${pkgs.stdenv.hostPlatform.system}.lix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
      "flake-self-attrs"
    ];
  };
}
