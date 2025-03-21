with builtins; filter isString (split "\n" (readFile (fetchurl "https://github.com/Henry-Hiles.keys")))
