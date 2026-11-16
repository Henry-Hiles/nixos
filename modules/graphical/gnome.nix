{
  config,
  lib,
  pkgs,
  ...
}:
{
  services = {
    gnome = {
      core-os-services.enable = true;
      core-apps.enable = true;
    };

    gvfs.enable = true;
  };

  systemd.user.tmpfiles.users.quadradical.rules =
    let
      keyring = pkgs.writeText "login.keyring" ''
        [keyring]
        display-name=Login
        ctime=0
        mtime=0
        lock-on-idle=false
        lock-after=false
      '';
    in
    [
      "d %h/.local/share/keyrings 0700 - - -"
      "C %h/.local/share/keyrings/login.keyring 0600 - - - ${keyring}"
      "f %h/.local/share/keyrings/default 0600 - - - login"
    ];

  environment.sessionVariables.NAUTILUS_4_EXTENSION_DIR = lib.mkForce "${config.system.path}/lib/nautilus/extensions-4";

  environment.gnome.excludePackages = with pkgs; [
    yelp
    orca
    totem
    xterm
    evince
    decibels
    epiphany
    gnome-logs
    gnome-tour
    gnome-music
    simple-scan
    gnome-console
    gnome-software
    gnome-user-docs
    gnome-characters
    gnome-font-viewer
    gnome-connections
    gnome-text-editor
    gnome-system-monitor
  ];

  users.users.quadradical.maid.gsettings.settings.org.gnome = {
    desktop = {
      interface = rec {
        color-scheme = "prefer-dark";

        cursor-theme = "GoogleDot-Blue";
        cursor-size = 24;

        icon-theme = "Papirus";
        toolkit-accessibility = false;

        font-name = "sans 11";
        document-font-name = font-name;
        monospace-font-name = "monospace";
      };

      lockdown = {
        disable-printing = true;
        disable-print-setup = true;
      };
    };
  };
}
