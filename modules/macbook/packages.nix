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
        devenv
        awscli2
        ssm-session-manager-plugin
        ffmpeg-headless
        yt-dlp
        poppler-utils
        opentofu
        terragrunt

        # applications
        shottr
        raycast
        ghostty-bin
        iina
      ];
    };
}
