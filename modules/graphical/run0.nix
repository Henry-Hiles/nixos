{ inputs, ... }:
{
  imports = [ inputs.run0-sudo-shim.nixosModules.default ];
  security.run0-sudo-shim.enable = true;
}
