{
  pkgs,
  inputs,
  dirUtils,
  type,
  ...
}: {
  environment.systemPackages = [
    (inputs.wrapper-manager.lib {
      inherit pkgs;
      specialArgs = {inherit inputs;};
      modules = with dirUtils; dirFiles ".nix" ./common ++ opt (type == "desktop") (dirFiles ".nix" ./desktop);
    })
    .config.build.toplevel
  ];
}
