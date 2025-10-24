{ config, ... }:
{
  services.draupnir = {
    enable = false; # Blocked on https://forgejo.ellis.link/continuwuation/continuwuity/issues/1098
    settings =
      let
        serverName = config.quad.matrix.domain;
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
