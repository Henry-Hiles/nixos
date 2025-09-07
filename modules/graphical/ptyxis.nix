{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.ptyxis
  ];

  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "ptyxis";
  };

  users.users.quadradical.maid.gsettings.settings.org.gnome.Ptyxis = rec {
    default-profile-uuid = "quadradical";
    profile-uuids = [default-profile-uuid];
    Profiles.${default-profile-uuid}.palette = "nord";
  };
}
