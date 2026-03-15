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

        # applications
        shottr
        raycast
        ghostty-bin
        iina
      ];
    };
}
