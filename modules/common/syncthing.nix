{ ... }:
{
  flake.modules.homeManager.syncthing =
    { pkgs, config, ... }:
    {
      home.packages = with pkgs; [ syncthing ];

      services.syncthing = {
        enable = true;
        extraOptions = [
          "--gui-address=127.0.0.1:8384"
          "--home=${config.xdg.stateHome}/syncthing"
        ];
        settings.gui.insecureSkipHostcheck = true;
      };
    };
}
