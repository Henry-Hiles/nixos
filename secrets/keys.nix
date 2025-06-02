with builtins;
  filter (line: isString line && stringLength line != 0) (split "\n" (readFile (fetchurl {
    url = "https://git.federated.nexus/Henry-Hiles.keys";
    sha256 = "1k73c228rgzq7ymf5vaj6wfqzkqm6yzq5lq0syb7mzbrvngvr2jc";
  })))
