{
  pkgs,
  lib,
  ...
}: {
  hardware.keyboard.qmk.enable = true;
  environment.systemPackages = [
    (pkgs.qmk.overrideAttrs (oldAttrs: {
      propagatedBuildInputs = (oldAttrs.propagatedBuildInputs or []) ++ [pkgs.python3.pkgs.appdirs];
    }))
  ];

  systemd.tmpfiles.settings.qmk = {
    "/home/quadradical/.config/qmk"."d".user = "quadradical";
    "/home/quadradical/.config/qmk/qmk.ini"."f+".argument = lib.replaceStrings ["\n"] ["\\n"] (lib.generators.toINI {} {
      user = {
        qmk_home = "/home/quadradical/Documents/Code/qmk_firmware";
        overlay_dir = "/home/quadradical/Documents/Code/qmk_userspace";
        keyboard = "keychron/v1_max/ansi_encoder";
        keymap = "default";
      };
    });
  };
}
