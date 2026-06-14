{
  flake.modules.nixos.media-server =
    { ... }:
    {
      users.groups.media = { };

      systemd.tmpfiles.rules = [
        "d /media 2775 root media -"
        "d /media/downloads 2775 root media -"
        "d /media/downloads/.incomplete 2775 root media -"
        "d /media/movies 2775 root media -"
        "d /media/tv 2775 root media -"
        "d /media/music 2775 root media -"
        "d /media/books 2775 root media -"
      ];
    };
}
