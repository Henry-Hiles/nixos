{ pkgs, inputs, ... }:
{
  services.caddy.virtualHosts =
    let
      commonConf = {
        defaultHomeserver = 0;
        homeserverList = [ "federated.nexus" ];
        allowCustomHomeservers = false;

        disableAccountSwitcher = true;

        featuredCommunities = {
          spaces = { };
          rooms = { };
        };

        settingsDefaults = {
          themeId = "cinny-dark";
          darkThemeId = "cinny-dark-theme";
          themeCatalogOnboardingDone = true;
          themeRemoteCatalogEnabled = true;

          renderGlobalNameColors = false;
          renderUserCards = "none";
          renderRoomColors = false;
          renderRoomFonts = false;

          hour24Clock = true;

        };
      };
      mkCinny = package: extraConf: {
        extraConfig = ''
          root ${
            pkgs.cinny.override {
              conf = commonConf // extraConf;
              cinny-unwrapped = package;
            }
          }
          try_files {path} {path}/ /index.html
          file_server
        '';
      };
    in
    {
      "app.federated.nexus" =
        mkCinny inputs.sable.packages.${pkgs.stdenv.hostPlatform.system}.default
          { };

      "staging.app.federated.nexus" =
        mkCinny inputs.sable.packages.${pkgs.stdenv.hostPlatform.system}.default
          { };
    };
}
