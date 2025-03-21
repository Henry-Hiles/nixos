{
  inputs,
  lib,
  ...
}: {
  environment.systemPackages = [inputs.ragenix.packages.x86_64-linux.default];

  age.secrets = with lib;
    listToAttrs (mapAttrsToList (name: _: {
      name = name;
      value.file = name;
    }) (import ../../secrets/secrets.nix));
}
