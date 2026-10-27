{
  inputs,
  lib,
  config,
  crossPkgs,
  ...
}:
{
  imports = [
    (
      _:
      import inputs.nixphone.nixosModules.sdm845-oneplus-fajita {
        inherit lib config;
        pkgs = crossPkgs;
        inputs = inputs.sdm845.inputs;
      }
    )
  ];
}
