{
  flake.modules.homeManager.packages =
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
        openbao

        # applications
        shottr
        raycast
        ghostty-bin
        iina
      ];
    };
}
