{
  config,
  pkgs,
  lib,
  ...
}:
{
  environment.etc = {
    "xdg/walker/config.toml".source = (pkgs.formats.toml { }).generate "walker.toml" {
      force_keyboard_focus = true;
      theme = "system";
    };

    "xdg/walker/themes/system/style.css".source = pkgs.runCommand "walker-system-style.css" { } ''
      sed '/^@define-color/d' ${pkgs.walker.src}/resources/themes/default/style.css > $out
    '';

    "xdg/elephant/elephant.toml".source = (pkgs.formats.toml { }).generate "elephant.toml" {
      terminal_cmd = "ptyxis -x";
      ignored_providers = [
        "1password"
        "aptpackages"
        "archlinuxpkgs"
        "bitwarden"
        "bluetooth"
        "bookmarks"
        "clipboard"
        "dnfpackages"
        "files"
        "menus"
        "niriactions"
        "nirisessions"
        "playerctl"
        "protonpass"
        "providerlist"
        "runner"
        "snippets"
        "symbols"
        "todo"
        "unicode"
        "windows"
        "wireplumber"
      ];
    };

    "xdg/elephant/websearch.toml".source =
      let
        inherit (config.programs.firefox.policies) SearchEngines;
      in
      (pkgs.formats.toml { }).generate "websearch.toml" {
        entries = map (
          engine:
          {
            name = engine.Name;
            url = lib.replaceStrings [ "{searchTerms}" ] [ "%TERM%" ] engine.URLTemplate;
            default = engine.Name == SearchEngines.Default;
          }
          // lib.optionalAttrs (engine ? Alias) { prefix = "${engine.Alias} "; }
        ) SearchEngines.Add;
      };
  };

  programs.fht-compositor = {
    sessionPrograms = {
      elephant = lib.getExe pkgs.elephant;
      walker = "walker --gapplication-service";
    };

    settings.keybinds.Super_L = {
      action = "run-command";
      arg = "walker";
    };
  };
}
