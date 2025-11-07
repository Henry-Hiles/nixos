{
  inputs,
  pkgs,
  ...
}:
{
  wrappers.agenix = {
    basePackage = inputs.agenix-cli.packages.${pkgs.stdenv.hostPlatform.system}.default;

    env.AGENIX_ROOT.value =
      let
        path = ".agenix.toml";
      in
      pkgs.writeTextDir path (
        builtins.readFile (
          pkgs.writers.writeTOML path {
            paths = [
              {
                glob = "**";
                identities = import ../../secrets/keys.nix;
              }
            ];
          }
        )
      );
  };
}
