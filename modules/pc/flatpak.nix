{ inputs, ... }:
{
  flake.modules.homeManager.flatpak =
    { ... }:
    {
      imports = [
        inputs.nix-flatpak.homeManagerModules.nix-flatpak
      ];

      services.flatpak = {
        enable = true;
        update.onActivation = true;

        packages = [
          "org.vinegarhq.Sober"
        ];

        overrides = {
          "org.vinegarhq.Sober" = {
            Context = {
              filesystems = [
                "xdg-run/app/com.discordapp.Discord:create"
                "xdg-run/discord-ipc-0"
              ];
              talk-name = [ "com.feralinteractive.GameMode" ]; # talk to GameMode daemon
              devices = [ "input" ];
            };
          };
        };
      };

      home.sessionVariables = {
        # get flatpaks to show up in rofi
        XDG_DATA_DIRS = "$XDG_DATA_DIRS:$HOME/.local/share/flatpak/exports/share";
      };
    };
}
