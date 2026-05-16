{ inputs, ... }:
{
  flake.modules.homeManager.mac-packages =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        docker
        docker-compose
        colima
        sshpass
        typst
        ragenix
        bun
        uv
        nodejs
        pnpm
        openbao
        inputs.devenv.packages.${pkgs.stdenv.hostPlatform.system}.default
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
