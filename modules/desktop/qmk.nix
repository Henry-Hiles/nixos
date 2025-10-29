{ pkgs, ... }:
{
  hardware.keyboard.qmk.enable = true;
  environment.systemPackages = [
    (pkgs.qmk.overrideAttrs (oldAttrs: {
      propagatedBuildInputs = (oldAttrs.propagatedBuildInputs or [ ]) ++ [ pkgs.python3.pkgs.appdirs ];
    }))
  ];

  users.users.quadradical.maid.file.xdg_config."qmk/qmk.ini".source = toString (
    (pkgs.formats.ini { }).generate "qmk.ini" {
      user = {
        qmk_home = "/home/quadradical/Documents/Code/qmk_firmware";
        overlay_dir = "/home/quadradical/Documents/Code/qmk_userspace";
        keyboard = "nuphy/air75_v2/ansi";
        keymap = "via";
      };
    }
  );
}
