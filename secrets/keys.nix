with builtins;
  filter isString (split "\n" (readFile (fetchurl {
    url = "https://github.com/Henry-Hiles.keys";
    sha256 = "1k73c228rgzq7ymf5vaj6wfqzkqm6yzq5lq0syb7mzbrvngvr2jc";
  })))
