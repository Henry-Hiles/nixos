{
  nix.settings = {
    experimental-features = [
      "auto-allocate-uids"
      "cgroups"
    ];
    auto-allocate-uids = true;
    system-features = [ "uid-range" ];
    use-cgroups = true;
  };
}
