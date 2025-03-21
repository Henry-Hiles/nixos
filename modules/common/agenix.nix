{
  dirUtils,
  inputs,
  lib,
  ...
}: let
  secretsPath = ../../secrets;
in {
  environment.systemPackages = [inputs.agenix.packages.x86_64-linux.default]; # TODO: USE WRAPPER

  age.secrets = lib.listToAttrs (map (name: _: {
    name = name;
    value.file = "${secretsPath}/${name}";
  }) (lib.filter (name: lib.hasSuffix ".age" name) (dirUtils.dirFiles secretsPath)));
}
