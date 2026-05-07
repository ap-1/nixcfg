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
        awscli2
        ssm-session-manager-plugin
        ffmpeg-headless
        yt-dlp
        poppler-utils
        opentofu
        terragrunt
        kubectl
        kubernetes-helm
        argocd
        (proxmark3.override { hardwarePlatform = "PM3GENERIC"; })

        # applications
        shottr
        raycast
        ghostty-bin
        iina
      ];
    };
}
