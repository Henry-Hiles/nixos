{
  lib,
  buildLinux,
  fetchFromGitLab,
  ...
} @ args: let
  src = fetchFromGitLab {
    owner = "sdm845-mainline";
    repo = "linux";
    rev = "sdm845/6.16-dev";
    hash = "sha256-Nu7BwSl40Ytm7nCzyctNed7nqwq7NcVVxHLF3KFMKC4=";
  };
  version = "${rec {
    file = "${src}/Makefile";
    version = toString (builtins.match ".+VERSION = ([0-9]+).+" (builtins.readFile file));
    patchlevel = toString (builtins.match ".+PATCHLEVEL = ([0-9]+).+" (builtins.readFile file));
    sublevel = toString (builtins.match ".+SUBLEVEL = ([0-9]+).+" (builtins.readFile file));
    extraversion = toString (builtins.match ".+EXTRAVERSION = ([a-z0-9-]+).+" (builtins.readFile file));
    string = "${version + "." + patchlevel + "." + sublevel + (lib.optionalString (extraversion != "") extraversion)}";
  }.string}";
in (buildLinux (
  args
  // {
    inherit src version;
    modDirVersion = version;
    extraMeta = {
      platforms = ["aarch64-linux"];
      hydraPlatforms = [""];
    };
  }
  // (args.argsOverride or {})
))
