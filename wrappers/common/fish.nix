{ pkgs, ... }:
{
  wrappers.fish = {
    basePackage = pkgs.fish;
    env.fish_greeting.value = "";
  };
}
