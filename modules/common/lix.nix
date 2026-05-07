{ inputs, pkgs, ... }:
{
  nix.package = inputs.nixpkgs-master.legacyPackages.${pkgs.stdenv.hostPlatform.system}.lix;
}
