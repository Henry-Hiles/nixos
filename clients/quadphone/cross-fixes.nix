{
  inputs,
  lib,
  ...
}:
{
  nixpkgs.overlays = [
    (final: prev: {
      gnome = prev.gnome // {
        nixos-gsettings-overrides = prev.gnome.nixos-gsettings-overrides.override {
          glib = final.buildPackages.glib;
        };
      };

      # Meson looks for gio and gdbus-codegen for the build machine
      gnome-session = prev.gnome-session.overrideAttrs (old: {
        depsBuildBuild = (old.depsBuildBuild or [ ]) ++ [
          final.pkgsBuildBuild.pkg-config
          final.pkgsBuildBuild.glib
        ];
      });
    })
  ];

  # TODO: flutter apps don't cross compile, and the flake's package isn't cached
  programs.nexus.enable = lib.mkForce false;

  # The cache builder doesn't find gtk-query-immodules-3.0 when cross compiling,
  # and GNOME Shell connects apps to IBus itself, so the GTK module isn't used anyway.
  i18n.inputMethod.enableGtk3 = false;

  # Needs python gi on the build machine, and only connects desktop browsers to
  # extensions.gnome.org anyway.
  services.gnome.gnome-browser-connector.enable = false;

  # nix-maid runs the host mustache-go at build time, swap in a copy of its core
  # module that uses the build platform's one for that step.
  # TODO: upstream (use pkgs.buildPackages.mustache-go in core.nix)
  maid.sharedModules =
    let
      core = "${inputs.nix-maid}/src/maid/modules/core.nix";
    in
    [
      {
        disabledModules = [ core ];
        imports = [
          (builtins.toFile "nix-maid-core.nix" (
            builtins.replaceStrings
              [ "import ../vars.nix" "lib.getExe pkgs.mustache-go" ]
              [ "import ${inputs.nix-maid}/src/maid/vars.nix" "lib.getExe pkgs.buildPackages.mustache-go" ]
              (builtins.readFile core)
          ))
        ];
      }
    ];
}
