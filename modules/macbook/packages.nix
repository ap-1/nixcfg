{ ... }:
{
  flake.modules.homeManager.mac-packages =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        docker
        docker-compose
        colima
        container
        sshpass
        typst
        ragenix
        bun
        uv
        nodejs
        pnpm
        openbao
        devenv
        ffmpeg-headless
        yt-dlp
        poppler-utils
        (proxmark3.override { hardwarePlatform = "PM3GENERIC"; })

        # applications
        shottr
        ghostty-bin
        iina
      ];
    };
}
