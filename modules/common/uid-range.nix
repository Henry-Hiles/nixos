{
  nix.settings = {
    experimental-features = [
      "auto-allocate-uids"
    ];
    auto-allocate-uids = true;
    system-features = [ "uid-range" ];
  };
}
