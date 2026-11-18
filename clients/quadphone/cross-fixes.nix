{
  lib,
  ...
}:
{
  # TODO: flutter apps don't cross compile, and the flake's package isn't cached
  programs.nexus.enable = lib.mkForce false;
}
