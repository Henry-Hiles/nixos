{ config, ... }:
{
  services.draupnir = {
    enable = true;
    settings = rec {
      homeserverUrl = config.services.matrix-continuwuity.settings.global.well_known.client;
      rawHomeserverUrl = homeserverUrl;

      managementRoom = "#moderators:${config.services.matrix-continuwuity.settings.global.server_name}";

      autojoinOnlyIfManager = false;
      protectAllJoinedRooms = true;

      roomStateBackingStore.enabled = false;

      commands = {
        allowNoPrefix = true;
        symbolPrefixes = [ "/" ];
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
