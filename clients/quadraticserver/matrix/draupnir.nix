{ config, ... }:
{
  services.draupnir = {
    enable = true;
    settings =
      let
        serverName = config.services.matrix-continuwuity.settings.global.server_name;
        homeserverUrl = config.services.matrix-continuwuity.settings.global.well_known.client;
      in
      {
        inherit homeserverUrl;
        rawHomeserverUrl = homeserverUrl;

        managementRoom = "#moderators:${serverName}";

        autojoinOnlyIfManager = false;
        acceptInvitesFromSpace = "#space:${serverName}";
        protectAllJoinedRooms = true;

        roomStateBackingStore.enabled = false;

        commands = {
          allowNoPrefix = true;
          ban.defaultReasons = [
            "spam"
            "advertising"
            "harassment"
            "troll"
          ];
        };

      };
    secrets.accessToken = config.age.secrets."draupnir.age".path;
  };
}
