{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.yt-dlp ];

  # Defaults to downloading music: playlists into ~/Music/Artist - Album/, single songs into ~/Music/Singles/
  # Use --ignore-config for anything else
  environment.etc."yt-dlp.conf".text = ''
    -x
    --no-playlist
    --embed-metadata
    --embed-thumbnail
    --convert-thumbnails jpg
    --ppa "ThumbnailsConvertor:-qmin 1 -q:v 1 -vf crop=\"'if(gt(ih,iw),iw,ih)':'if(gt(iw,ih),ih,iw)'\""
    --parse-metadata "playlist_index:%(track_number)s"
    --parse-metadata "%(playlist_id&@@|)s%(artist,uploader)s - %(album,playlist_title)s:@@(?P<album_dir>.+)"
    -P ~/Music
    -o "%(album_dir|Singles)s/%(title)s.%(ext)s"
  '';
}
