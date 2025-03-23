{
  dirUtils,
  inputs,
  lib,
  ...
}: {
  environment.systemPackages = [inputs.agenix.packages.x86_64-linux.default];
  age = {
    identityPaths = [
      "/home/quadradical/.ssh/id_ed25519"
    ];
    secrets = lib.listToAttrs (map (path: {
      name = lib.last (builtins.split "/" (toString path));
      value.file = path;
    }) (dirUtils.dirFiles ".age" ../../secrets));
  };
}
