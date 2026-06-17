{
  flake.modules.homeManager.cortado-packages =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        colima
        container
        sshpass
        typst
        bun
        uv
        openbao
        ffmpeg-headless
        yt-dlp
        poppler-utils
        (proxmark3.override { hardwarePlatform = "PM3GENERIC"; })

        # applications
        shottr
        iina
      ];
    };
}
