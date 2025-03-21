{lib, ...}:
with builtins;
  listToAttrs (map (file: {
    name = file;
    value.publicKeys = split "\n" (readFile (fetchurl "https://github.com/Henry-Hiles.keys"));
  }) (filter (name: lib.hasSuffix ".age" name) (builtins.attrNames (builtins.readDir ./.))))
