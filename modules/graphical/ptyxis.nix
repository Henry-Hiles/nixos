{ pkgs, ... }:
{
  environment.systemPackages = [
    # Ptyxis is single-instance, so plain `ptyxis` just focuses the existing window
    (pkgs.symlinkJoin {
      name = "ptyxis";
      paths = [ pkgs.ptyxis ];
      postBuild = ''
        desktop=$out/share/applications/org.gnome.Ptyxis.desktop
        cp --remove-destination "$(readlink "$desktop")" "$desktop"
        sed -i -e 's/^Exec=ptyxis$/Exec=ptyxis --new-window/' -e '/^DBusActivatable=/d' "$desktop"
      '';
    })
  ];

  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "ptyxis";
  };

  users.users.quadradical.maid.gsettings.settings.org.gnome.Ptyxis = rec {
    default-profile-uuid = "quadradical";
    profile-uuids = [ default-profile-uuid ];
    Profiles.${default-profile-uuid}.palette = "nord";
  };
}
