{ ... }:
{
  flake.modules.homeManager.syncthing =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ syncthing ];

      services.syncthing = {
        enable = true;
        extraOptions = [
          "--gui-address=127.0.0.1:8384"
        ];
        settings.gui.insecureSkipHostcheck = true;
      };
    };
}
